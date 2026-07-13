package com.example.demo.dao;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.stereotype.Repository;

import com.example.demo.model.Productdetail;

@Repository
public class ProductdetailDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;


    // 商品詳細を1件取得する
    // is_main = 0 がメイン画像
    public Productdetail findById(int id) {

        String sql =
            """
            SELECT
                p.id,
                p.name,
                p.description,
                p.ken,
                p.hard,
                p.kinds,
                p.base,
                pv.variant_image_url AS imageUrl,
                pv.price,
                pv.stock
            FROM products p
            LEFT JOIN product_variants pv
                ON p.id = pv.product_id
                AND pv.is_main = 0
            WHERE p.id = ?
            LIMIT 1
            """;

        try {

            return jdbcTemplate.queryForObject(
                sql,
                new BeanPropertyRowMapper<>(Productdetail.class),
                id
            );

        } catch (Exception e) {

            e.printStackTrace();
            return null;
        }
    }



    // 在庫を減らす
    public boolean reduceStock(int variantId, int quantity) {

        String sql =
            """
            UPDATE product_variants
            SET stock = stock - ?
            WHERE id = ?
            AND stock >= ?
            """;


        int updatedRows =
            jdbcTemplate.update(
                sql,
                quantity,
                variantId,
                quantity
            );


        return updatedRows > 0;
    }



    // 商品IDに紐づくサブ画像一覧
    public List<Map<String, Object>> findImagesByProductId(int productId) {

        String sql =
            """
            SELECT
                id,
                image_url AS imageUrl
            FROM product_images
            WHERE product_id = ?
            ORDER BY sort_order
            """;


        return jdbcTemplate.queryForList(sql, productId);
    }



    // 商品IDに紐づく全バリエーション取得
    public List<Map<String, Object>> findVariantsByProductId(int productId) {

        String sql =
            """
            SELECT
                id,
                size_or_color AS label,
                price,
                stock,
                variant_image_url AS imageUrl
            FROM product_variants
            WHERE product_id = ?
            ORDER BY id ASC
            """;


        return jdbcTemplate.queryForList(sql, productId);
    }



    // バリエーションIDから取得
    public Map<String, Object> findVariantById(int variantId) {

        String sql =
            """
            SELECT
                id,
                size_or_color AS name,
                price,
                stock,
                variant_image_url AS imageUrl
            FROM product_variants
            WHERE id = ?
            """;


        return jdbcTemplate.queryForMap(sql, variantId);
    }



    // 関連商品4件取得（Pythonの関連商品APIが使えない時のフォールバック用）
    // メイン画像(is_main=0)を表示
    // ORDER BY RAND() で毎回ランダムな4件を返す
    public List<Map<String, Object>> findRelatedProducts(int productId) {

        String sql =
            """
            SELECT
                p.id,
                p.name,
                pv.variant_image_url AS imageUrl,
                pv.price
            FROM products p
            LEFT JOIN product_variants pv
                ON p.id = pv.product_id
                AND pv.is_main = 0
            WHERE p.id <> ?
            ORDER BY RAND()
            LIMIT 4
            """;


        return jdbcTemplate.queryForList(sql, productId);
    }



    // バリエーション画像取得
    public List<Map<String, Object>> findVariantImagesByProductId(int productId) {

        String sql =
            """
            SELECT
                id,
                variant_image_url AS imageUrl
            FROM product_variants
            WHERE product_id = ?
            AND variant_image_url IS NOT NULL
            ORDER BY id ASC
            """;


        return jdbcTemplate.queryForList(sql, productId);
    }

// 配送先情報を保存してdelivery_idを返す
public int insertDelivery(Map<String, String> orderData) {

    String sql =
        """
        INSERT INTO delivery
        (
            last_name,
            first_name,
            last_name_kana,
            first_name_kana,
            postal_code,
            prefecture,
            address1,
            address2
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;


    GeneratedKeyHolder keyHolder = new GeneratedKeyHolder();


    jdbcTemplate.update(connection -> {

        PreparedStatement ps =
            connection.prepareStatement(
                sql,
                Statement.RETURN_GENERATED_KEYS
            );


        ps.setString(1, orderData.get("lastName"));
        ps.setString(2, orderData.get("firstName"));
        ps.setString(3, orderData.get("lastNameKana"));
        ps.setString(4, orderData.get("firstNameKana"));
        ps.setString(5, orderData.get("zipCode"));
        ps.setString(6, orderData.get("prefecture"));
        ps.setString(7, orderData.get("address1"));
        ps.setString(8, orderData.get("address2"));


        return ps;

    }, keyHolder);


    return keyHolder.getKey().intValue();
}




// 注文を保存して注文IDを返す
public int insertOrder(int userId, int deliveryId) {

    String sql =
        """
        INSERT INTO orders
        (
            user_id,
            order_date,
            status,
            delivery_id
        )
        VALUES
        (
            ?,
            NOW(),
            '注文完了',
            ?
        )
        """;


    GeneratedKeyHolder keyHolder =
        new GeneratedKeyHolder();


    jdbcTemplate.update(connection -> {

        PreparedStatement ps =
            connection.prepareStatement(
                sql,
                Statement.RETURN_GENERATED_KEYS
            );


        ps.setInt(1, userId);
        ps.setInt(2, deliveryId);


        return ps;


    }, keyHolder);



    return keyHolder.getKey().intValue();
}





// 注文明細を保存
public void insertOrderDetail(
        int orderId,
        int variantId,
        int quantity,
        int price,
        int sumPrice) {


    String sql =
        """
        INSERT INTO order_details
        (
            order_id,
            variant_id,
            quantity,
            price,
            sum_price
        )
        VALUES (?, ?, ?, ?, ?)
        """;


    jdbcTemplate.update(
        sql,
        orderId,
        variantId,
        quantity,
        price,
        sumPrice
    );
}

}