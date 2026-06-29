package com.example.demo.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.model.ProductVariant;

@Repository
public class ProductVariantDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // バリエーションを登録する
    public int insert(ProductVariant variant) {
        String sql = "INSERT INTO product_variants (product_id, size_or_color, price, variant_image_url, stock, litl) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        return jdbcTemplate.update(sql,
            variant.getProductId(),
            variant.getSizeOrColor(),
            variant.getPrice(),
            variant.getVariantImageUrl(),
            variant.getStock(),
            variant.getLitl()
        );
    }
}

