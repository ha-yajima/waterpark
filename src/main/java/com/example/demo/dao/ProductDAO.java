package com.example.demo.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.model.Product;
import com.example.demo.model.ProductFormItem;

@Repository
public class ProductDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 商品一覧を全件取得する
    public List<Product> findAll() {
        String sql = "SELECT * FROM products ORDER BY id DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Product.class));
    }

    // IDを指定して商品を1件取得する
    public Product findById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Product.class), id);
    }

    // 新しい商品を登録する（登録された商品のIDを返す）
    public int insert(Product product) {
        // 📝 productsテーブル本来の構成に戻しました（画像カラムは含めない）
        String sql = "INSERT INTO products (name, description, created_at, hard, ken, kinds, base, is_recommended, rank) " +
                     "VALUES (?, ?, NOW(), ?, ?, ?, ?, ?, ?)";
        
        // インサートを実行
        jdbcTemplate.update(sql, 
            product.getName(), 
            product.getDescription(), 
            product.getHard(), 
            product.getKen(), 
            product.getKinds(), 
            product.getBase(), 
            product.getIsRecommended(), 
            product.getRank()
        );

        // 直前に自動採番された最新の id (AUTO_INCREMENTの値) を取得して返す
        return jdbcTemplate.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);
    }

    public List<ProductFormItem> findJoinedAll() {
        // 📸 SQLのSELECT項目に v.variant_image_url AS variantImageUrl を追加しました！
        String sql = "SELECT p.id AS productId, v.id AS variantId, p.name, p.kinds, p.base, v.litl, v.size_or_color AS sizeOrColor, v.price, v.stock, v.variant_image_url AS variantImageUrl " +
                     "FROM products p " +
                     "INNER JOIN product_variants v ON p.id = v.product_id " +
                     "ORDER BY p.id DESC, v.id ASC";
                     
        return jdbcTemplate.query(sql, new org.springframework.jdbc.core.BeanPropertyRowMapper<>(ProductFormItem.class));
    }

    // 編集用に、特定のproductIdに紐づく全バリエーションを入力フォーム用クラスのリストとして取得する
    public List<com.example.demo.model.ProductFormItem.VariantInput> findVariantsByProductId(int productId) {
        // 📸 variant_image_url を取得して、既存のメイン画像パスとしてバリエーションフォームに引き継ぐ
        String sql = "SELECT id AS variantId, size_or_color AS sizeOrColor, price, stock, litl, variant_image_url AS existingImageUrl " +
                     "FROM product_variants WHERE product_id = ? ORDER BY id ASC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(com.example.demo.model.ProductFormItem.VariantInput.class), productId);
    }

    // 親商品（products）を更新する
    public void update(Product product) {
        // 📝 productsテーブル本来の構成に戻しました（画像カラムは含めない）
        String sql = "UPDATE products SET name = ?, description = ?, hard = ?, ken = ?, kinds = ?, base = ? WHERE id = ?";
        jdbcTemplate.update(sql, 
            product.getName(), 
            product.getDescription(), 
            product.getHard(), 
            product.getKen(), 
            product.getKinds(), 
            product.getBase(),
            product.getId()
        );
    }

    // 特定のバリエーション（product_variants）を更新する
    public void updateVariant(com.example.demo.model.ProductFormItem.VariantInput v) {
        // 📸 確定版シートの通り「variant_image_url」を更新
        String sql = "UPDATE product_variants SET size_or_color = ?, price = ?, stock = ?, litl = ?, variant_image_url = ? WHERE id = ?";
        jdbcTemplate.update(sql, v.getSizeOrColor(), v.getPrice(), v.getStock(), v.getLitl(), v.getVariantImageUrl(), v.getVariantId());
    }
    
    // 🗑️ 特定の商品に紐づくバリエーションをすべて削除する
    public void deleteVariantsByProductId(int productId) {
        String sql = "DELETE FROM product_variants WHERE product_id = ?";
        jdbcTemplate.update(sql, productId);
        System.out.println("💥 product_id: " + productId + " のバリエーションをすべて削除しました。");
    }

    // 🗑️ 親商品を削除する
    public void delete(int productId) {
        String sql = "DELETE FROM products WHERE id = ?";
        jdbcTemplate.update(sql, productId);
        System.out.println("💥 productsテーブルから id: " + productId + " を削除しました。");
    }
    
    // 🔍 商品名（部分一致）で結合データを検索する
    public List<ProductFormItem> findJoinedByName(String keyword) {
        // 📸 こちらのSQLのSELECT項目にも v.variant_image_url AS variantImageUrl を追加しました！
        String sql = "SELECT p.id AS productId, v.id AS variantId, p.name, p.kinds, p.base, v.litl, v.size_or_color AS sizeOrColor, v.price, v.stock, v.variant_image_url AS variantImageUrl " +
                     "FROM products p " +
                     "INNER JOIN product_variants v ON p.id = v.product_id " +
                     "WHERE p.name LIKE ? " +
                     "ORDER BY p.id DESC, v.id ASC";
                     
        String likeKeyword = "%" + keyword + "%";
        
        return jdbcTemplate.query(sql, new org.springframework.jdbc.core.BeanPropertyRowMapper<>(ProductFormItem.class), likeKeyword);
    }
    
    // 🔍 商品名が完全に一致する商品の「ID」を1件取得する
    public Integer findIdByName(String name) {
        String sql = "SELECT id FROM products WHERE name = ? LIMIT 1";
        try {
            return jdbcTemplate.queryForObject(sql, Integer.class, name);
        } catch (org.springframework.dao.EmptyResultDataAccessException e) {
            return null;
        }
    }
    
    public List<String> findSubImageUrlsByProductId(int productId) {
        String sql = "SELECT image_url FROM product_images WHERE product_id = ? ORDER BY sort_order ASC";
        return jdbcTemplate.queryForList(sql, String.class, productId);
    }
    
 // 📸 特定のproductIdに紐づくサブ画像（product_images）を1件取得する
    public String findSubImageUrlByProductId(int productId) {
        String sql = "SELECT image_url FROM product_images WHERE product_id = ? ORDER BY sort_order ASC LIMIT 1";
        try {
            return jdbcTemplate.queryForObject(sql, String.class, productId);
        } catch (org.springframework.dao.EmptyResultDataAccessException e) {
            return null; // 画像がない場合はnull
        }
    }

    // 📸 新規：サブ画像を product_images テーブルに登録する
    public void insertSubImages(int productId, List<String> imageUrls) {
        if (imageUrls == null || imageUrls.isEmpty()) {
            return;
        }
        
        String sql = "INSERT INTO product_images (product_id, image_url, is_main, sort_order) VALUES (?, ?, 0, ?)";
        
        int sortOrder = 1;
        for (String imageUrl : imageUrls) {
            // 空文字やぬるぽ対策（必要に応じて）
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                jdbcTemplate.update(sql, productId, imageUrl, sortOrder);
                sortOrder++; // 💡1枚登録するごとに並び順をインクリメント
            }
        }
        System.out.println("📸 product_id: " + productId + " にサブ画像を " + (sortOrder - 1) + " 枚登録しました。");
    }

    // 📸 削除：特定の商品のサブ画像をすべて削除する
    public void deleteSubImagesByProductId(int productId) {
        String sql = "DELETE FROM product_images WHERE product_id = ?";
        jdbcTemplate.update(sql, productId);
    }
    public void insertStockHistory(Integer variantId, String type, int quantity, Integer orderId) {
        String sql = "INSERT INTO stock_histories (variant_id, type, quantity, order_id, processed_at) VALUES (?, ?, ?, ?, NOW())";
        jdbcTemplate.update(sql, variantId, type, quantity, orderId);
    }
}

