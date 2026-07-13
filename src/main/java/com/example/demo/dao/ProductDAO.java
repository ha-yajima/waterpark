package com.example.demo.dao;

import java.util.ArrayList;
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

    // 商品一覧用：全商品を商品ごとに1件ずつ取得する（変更・7/3塩田）
    public List<ProductFormItem> findJoinedAll() {
        String sql =
                "SELECT " +
                "p.id AS productId, " +
                "v.id AS variantId, " +
                "p.name, " +
                "p.kinds, " +
                "p.base, " +
                "v.litl AS litl, " +
                "v.size_or_color AS sizeOrColor, " +
                "v.price AS price, " +
                "v.stock AS stock, " +
                "v.variant_image_url AS variantImageUrl " +
                "FROM products p " +
                "INNER JOIN product_variants v " +
                "ON p.id = v.product_id " +
                "INNER JOIN ( " +
                "    SELECT product_id, MIN(id) AS min_variant_id " +
                "    FROM product_variants " +
                "    GROUP BY product_id " +
                ") first_variant " +
                "ON v.product_id = first_variant.product_id " +
                "AND v.id = first_variant.min_variant_id " +
                "ORDER BY p.id DESC";
        return jdbcTemplate.query(
                sql,
                new org.springframework.jdbc.core.BeanPropertyRowMapper<>(ProductFormItem.class)
        );
    }


    // 編集用に、特定のproductIdに紐づく全バリエーションを入力フォーム用クラスのリストとして取得する
    public List<com.example.demo.model.ProductFormItem.VariantInput> findVariantsByProductId(int productId) {
        // 💡 ORDER BY id ASC を is_main ASC に変更
        String sql = "SELECT id AS variantId, size_or_color AS sizeOrColor, price, stock, litl, variant_image_url AS existingImageUrl, is_main AS isMain " +
                     "FROM product_variants WHERE product_id = ? ORDER BY is_main ASC";
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
    // ProductDAO.java に追記
    public void updateVariant(com.example.demo.model.ProductFormItem.VariantInput v) {
        String sql = "UPDATE product_variants SET size_or_color = ?, price = ?, stock = ?, litl = ?, variant_image_url = ? WHERE id = ?";
        
        jdbcTemplate.update(sql, 
            v.getSizeOrColor(), 
            v.getPrice(), 
            v.getStock(), 
            v.getLitl(), 
            v.getVariantImageUrl(), 
            v.getVariantId() 
        );
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
        
        // SQLはここで定義します
        String sql = "INSERT INTO product_images (product_id, image_url, sort_order) VALUES (?, ?, ?)";
        
        int sortOrder = 1;
        for (String imageUrl : imageUrls) {
            // 空文字やnullの対策
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

  //ここから2026.7.3追加（index用塩田）↓  

  //TOPページ用：おすすめ商品を5件取得する
    public List<ProductFormItem> findRecommendedTopProducts() {
    String sql =
            "SELECT p.id AS productId, v.id AS variantId, " +
            "p.name, p.kinds, p.base, " +
            "v.litl, v.size_or_color AS sizeOrColor, " +
            "v.price, v.stock, " +
            "v.variant_image_url AS variantImageUrl " +
            "FROM products p " +
            "INNER JOIN product_variants v ON p.id = v.product_id " +
            "WHERE p.is_recommended = 1 " +
            "ORDER BY RAND() " +
            "LIMIT 5";
    return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ProductFormItem.class));
    }
    //TOPページ用：ランキング商品を5件取得する
    public List<ProductFormItem> findRankingTopProducts() {
    String sql =
            "SELECT p.id AS productId, v.id AS variantId, " +
            "p.name, p.kinds, p.base, " +
            "v.litl, v.size_or_color AS sizeOrColor, " +
            "v.price, v.stock, " +
            "v.variant_image_url AS variantImageUrl " +
            "FROM products p " +
            "INNER JOIN product_variants v ON p.id = v.product_id " +
            "WHERE p.rank IS NOT NULL " +
            "ORDER BY p.rank ASC " +
            "LIMIT 5";
    return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ProductFormItem.class));
    }
    //TOPページ用：新着商品を5件取得する
    public List<ProductFormItem> findNewTopProducts() {
    String sql =
            "SELECT p.id AS productId, v.id AS variantId, " +
            "p.name, p.kinds, p.base, " +
            "v.litl, v.size_or_color AS sizeOrColor, " +
            "v.price, v.stock, " +
            "v.variant_image_url AS variantImageUrl " +
            "FROM products p " +
            "INNER JOIN product_variants v ON p.id = v.product_id " +
            "ORDER BY p.created_at DESC " +
            "LIMIT 5";
    return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ProductFormItem.class));
    }
    //商品一覧用：新着商品を商品ごとに20件取得する
    public List<ProductFormItem> findNewProducts() {
     String sql =
             "SELECT " +
             "p.id AS productId, " +
             "MIN(v.id) AS variantId, " +
             "p.name, p.kinds, p.base, " +
             "MIN(v.litl) AS litl, " +
             "MIN(v.size_or_color) AS sizeOrColor, " +
             "MIN(v.price) AS price, " +
             "MAX(v.stock) AS stock, " +
             "SUBSTRING_INDEX(GROUP_CONCAT(v.variant_image_url ORDER BY v.id ASC), ',', 1) AS variantImageUrl " +
             "FROM products p " +
             "INNER JOIN product_variants v ON p.id = v.product_id " +
             "GROUP BY p.id, p.name, p.kinds, p.base, p.created_at " +
             "ORDER BY p.created_at DESC, p.id DESC " +
             "LIMIT 20";
     return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ProductFormItem.class));
    }
    //商品一覧用：おすすめ商品を商品ごとに20件取得する
    public List<ProductFormItem> findRecommendedProducts() {
    String sql =
            "SELECT " +
            "p.id AS productId, " +
            "MIN(v.id) AS variantId, " +
            "p.name, p.kinds, p.base, " +
            "MIN(v.litl) AS litl, " +
            "MIN(v.size_or_color) AS sizeOrColor, " +
            "MIN(v.price) AS price, " +
            "MAX(v.stock) AS stock, " +
            "SUBSTRING_INDEX(GROUP_CONCAT(v.variant_image_url ORDER BY v.id ASC), ',', 1) AS variantImageUrl " +
            "FROM products p " +
            "INNER JOIN product_variants v ON p.id = v.product_id " +
            "WHERE p.is_recommended = 1 " +
            "GROUP BY p.id, p.name, p.kinds, p.base, p.created_at " +
            "ORDER BY p.id DESC " +
            "LIMIT 20";
    return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ProductFormItem.class));
    }
    //商品一覧用：ランキング商品を商品ごとに20件取得する
    public List<ProductFormItem> findRankingProducts() {
    String sql =
            "SELECT " +
            "p.id AS productId, " +
            "MIN(v.id) AS variantId, " +
            "p.name, p.kinds, p.base, " +
            "MIN(v.litl) AS litl, " +
            "MIN(v.size_or_color) AS sizeOrColor, " +
            "MIN(v.price) AS price, " +
            "MAX(v.stock) AS stock, " +
            "SUBSTRING_INDEX(GROUP_CONCAT(v.variant_image_url ORDER BY v.id ASC), ',', 1) AS variantImageUrl " +
            "FROM products p " +
            "INNER JOIN product_variants v ON p.id = v.product_id " +
            "WHERE p.rank IS NOT NULL " +
            "GROUP BY p.id, p.name, p.kinds, p.base, p.rank " +
            "ORDER BY p.rank ASC, p.id DESC " +
            "LIMIT 20";
    return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ProductFormItem.class));
    }
    //顧客側商品一覧用：都道府県で検索する
    public List<ProductFormItem> findJoinedByPrefecture(String prefecture) {
    String sql =
            "SELECT p.id AS productId, v.id AS variantId, " +
            "p.name, p.kinds, p.base, " +
            "v.litl, v.size_or_color AS sizeOrColor, " +
            "v.price, v.stock, " +
            "v.variant_image_url AS variantImageUrl " +
            "FROM products p " +
            "INNER JOIN product_variants v ON p.id = v.product_id " +
            "WHERE p.ken LIKE ? " +
            "ORDER BY p.id DESC, v.id ASC";
    String likePrefecture = "%" + prefecture + "%";
    return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ProductFormItem.class), likePrefecture);
    }
    //顧客側商品一覧用：種類・タイプを複数選択して検索する
    public List<ProductFormItem> findJoinedByTypeList(List<String> typeList) {
    StringBuilder sql = new StringBuilder();
    sql.append("SELECT p.id AS productId, v.id AS variantId, ");
    sql.append("p.name, p.kinds, p.base, ");
    sql.append("v.litl, v.size_or_color AS sizeOrColor, ");
    sql.append("v.price, v.stock, ");
    sql.append("v.variant_image_url AS variantImageUrl ");
    sql.append("FROM products p ");
    sql.append("INNER JOIN product_variants v ON p.id = v.product_id ");
    sql.append("WHERE ");
    for (int i = 0; i < typeList.size(); i++) {
        if (i > 0) {
            sql.append(" OR ");
        }
        sql.append("p.kinds LIKE ? ");
    }
    sql.append("ORDER BY p.id DESC, v.id ASC");
    Object[] params = new Object[typeList.size()];
    for (int i = 0; i < typeList.size(); i++) {
        params[i] = "%" + typeList.get(i) + "%";
    }
    return jdbcTemplate.query(
            sql.toString(),
            new BeanPropertyRowMapper<>(ProductFormItem.class),
            params
    );
    }
    //顧客側商品一覧用：硬度を複数選択して検索する
    public List<ProductFormItem> findJoinedByHardnessList(List<String> hardnessList) {
    StringBuilder sql = new StringBuilder();
    sql.append("SELECT p.id AS productId, v.id AS variantId, ");
    sql.append("p.name, p.kinds, p.base, ");
    sql.append("v.litl, v.size_or_color AS sizeOrColor, ");
    sql.append("v.price, v.stock, ");
    sql.append("v.variant_image_url AS variantImageUrl ");
    sql.append("FROM products p ");
    sql.append("INNER JOIN product_variants v ON p.id = v.product_id ");
    sql.append("WHERE ");
    for (int i = 0; i < hardnessList.size(); i++) {
        if (i > 0) {
            sql.append(" OR ");
        }
        sql.append("p.hard LIKE ? ");
    }
    sql.append("ORDER BY p.id DESC, v.id ASC");
    Object[] params = new Object[hardnessList.size()];
    for (int i = 0; i < hardnessList.size(); i++) {
        params[i] = "%" + hardnessList.get(i) + "%";
    }
    return jdbcTemplate.query(
            sql.toString(),
            new BeanPropertyRowMapper<>(ProductFormItem.class),
            params
    );
    }
    //顧客側商品一覧用：複数条件で検索する
    //顧客側商品一覧用：複数条件で検索する
    public List<ProductFormItem> findJoinedBySearchConditions(
        String keyword,
        String prefecture,
        List<String> hardness,
        List<String> type,
        Integer minPrice,
        Integer maxPrice) {
    StringBuilder sql = new StringBuilder();
    sql.append("SELECT ");
    sql.append("p.id AS productId, ");
    sql.append("v.id AS variantId, ");
    sql.append("p.name, ");
    sql.append("p.kinds, ");
    sql.append("p.base, ");
    sql.append("v.litl AS litl, ");
    sql.append("v.size_or_color AS sizeOrColor, ");
    sql.append("v.price AS price, ");
    sql.append("v.stock AS stock, ");
    sql.append("v.variant_image_url AS variantImageUrl ");
    sql.append("FROM products p ");
    sql.append("INNER JOIN product_variants v ");
    sql.append("ON p.id = v.product_id ");
    sql.append("INNER JOIN ( ");
    sql.append("    SELECT product_id, MIN(id) AS min_variant_id ");
    sql.append("    FROM product_variants ");
    sql.append("    GROUP BY product_id ");
    sql.append(") first_variant ");
    sql.append("ON v.product_id = first_variant.product_id ");
    sql.append("AND v.id = first_variant.min_variant_id ");
    sql.append("WHERE 1=1 ");
    List<Object> params = new ArrayList<>();
    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append("AND (p.name LIKE ? OR p.description LIKE ? OR p.base LIKE ?) ");
        params.add("%" + keyword + "%");
        params.add("%" + keyword + "%");
        params.add("%" + keyword + "%");
    }
    if (prefecture != null && !prefecture.trim().isEmpty()) {
        sql.append("AND p.ken LIKE ? ");
        params.add("%" + prefecture + "%");
    }
    if (hardness != null && !hardness.isEmpty()) {
        sql.append("AND (");
        for (int i = 0; i < hardness.size(); i++) {
            if (i > 0) {
                sql.append(" OR ");
            }
            sql.append("p.hard LIKE ? ");
            params.add("%" + hardness.get(i) + "%");
        }
        sql.append(") ");
    }
    if (type != null && !type.isEmpty()) {
        sql.append("AND (");
        for (int i = 0; i < type.size(); i++) {
            if (i > 0) {
                sql.append(" OR ");
            }
            sql.append("p.kinds LIKE ? ");
            params.add("%" + type.get(i) + "%");
        }
        sql.append(") ");
    }
    if (minPrice != null) {
        sql.append("AND v.price >= ? ");
        params.add(minPrice);
    }
    if (maxPrice != null) {
        sql.append("AND v.price < ? ");
        params.add(maxPrice);
    }
    sql.append("ORDER BY p.id DESC");
    return jdbcTemplate.query(
            sql.toString(),
            new BeanPropertyRowMapper<>(ProductFormItem.class),
            params.toArray()
    );
    }
    //キャンペーンページ用：ランキング上位3件を商品ごとに取得する
    public List<ProductFormItem> findRankingCampaignProducts() {
    String sql =
            "SELECT " +
            "p.id AS productId, " +
            "v.id AS variantId, " +
            "p.name, " +
            "p.kinds, " +
            "p.base, " +
            "v.litl AS litl, " +
            "v.size_or_color AS sizeOrColor, " +
            "v.price AS price, " +
            "v.stock AS stock, " +
            "v.variant_image_url AS variantImageUrl " +
            "FROM products p " +
            "INNER JOIN product_variants v " +
            "ON p.id = v.product_id " +
            "INNER JOIN ( " +
            "    SELECT product_id, MIN(id) AS min_variant_id " +
            "    FROM product_variants " +
            "    GROUP BY product_id " +
            ") first_variant " +
            "ON v.product_id = first_variant.product_id " +
            "AND v.id = first_variant.min_variant_id " +
            "WHERE p.rank IS NOT NULL " +
            "ORDER BY p.rank ASC, p.id DESC " +
            "LIMIT 3";
    return jdbcTemplate.query(
            sql,
            new BeanPropertyRowMapper<>(ProductFormItem.class)
    );
    }
    }
