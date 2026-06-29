package com.example.demo.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Productdetail;

@Repository
public class ProductdetailDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

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
                pi.image_url AS imageUrl,
                pv.price,
                pv.stock
            FROM products p
            LEFT JOIN product_images pi
                ON p.id = pi.product_id
                AND pi.is_main = 1
            LEFT JOIN product_variants pv
                ON p.id = pv.product_id
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

    public boolean reduceStock(int variantId, int quantity) {

        String sql =
            "UPDATE product_variants " +
            "SET stock = stock - ? " +
            "WHERE id = ? " +
            "AND stock >= ?";

        int updatedRows =
            jdbcTemplate.update(sql, quantity, variantId, quantity);

        return updatedRows > 0;
    }
    
    public java.util.List<java.util.Map<String, Object>> findImagesByProductId(int productId) {
        String sql =
            "SELECT id, image_url AS imageUrl " +
            "FROM product_images " +
            "WHERE product_id = ? " +
            "ORDER BY sort_order";
        return jdbcTemplate.queryForList(sql, productId);
    }
    
 // 指定された商品IDに紐づくすべてのバリエーション（サイズ・価格・在庫）を取得する 
    public java.util.List<java.util.Map<String, Object>> findVariantsByProductId(int productId) {

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
            """;

        return jdbcTemplate.queryForList(sql, productId);
    }

    
    
    public java.util.Map<String, Object> findVariantById(int variantId) {

        String sql =
            "SELECT id, size_or_color AS name, price, stock " +
            "FROM product_variants " +
            "WHERE id = ?";

        return jdbcTemplate.queryForMap(sql, variantId);
    }
    public java.util.List<java.util.Map<String,Object>> findRelatedProducts(int productId){

        String sql =
            """
            SELECT
                p.id,
                p.name,
                pi.image_url
            FROM products p
            LEFT JOIN product_images pi
                ON p.id = pi.product_id
                AND pi.is_main = 1
            WHERE p.id <> ?
            LIMIT 4
            """;

        return jdbcTemplate.queryForList(sql, productId);
    }
    
    public java.util.List<java.util.Map<String,Object>> findVariantImagesByProductId(int productId){

        String sql =
            """
            SELECT
                id,
                variant_image_url AS imageUrl
            FROM product_variants
            WHERE product_id = ?
            AND variant_image_url IS NOT NULL
            """;

        return jdbcTemplate.queryForList(sql, productId);
    }
    
    
    
}