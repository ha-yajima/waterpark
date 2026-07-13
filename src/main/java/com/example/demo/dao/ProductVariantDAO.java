package com.example.demo.dao;
import java.sql.PreparedStatement;
import java.sql.Statement;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.example.demo.model.ProductVariant;
@Repository
public class ProductVariantDAO {
   @Autowired
   private JdbcTemplate jdbcTemplate;
   // バリエーション情報の更新処理
   public int update(ProductVariant variant) {
       String sql = "UPDATE product_variants SET size_or_color = ?, price = ?, " +
                    "variant_image_url = ?, stock = ?, litl = ? WHERE id = ?";
      
       return jdbcTemplate.update(sql,
           variant.getSizeOrColor(),
           variant.getPrice(),
           variant.getVariantImageUrl(),
           variant.getStock(),
           variant.getLitl(),
           variant.getId()
       );
   }
   // バリエーション情報の新規登録処理
   public int insert(ProductVariant variant) {
       String sql = "INSERT INTO product_variants (product_id, size_or_color, price, stock, litl, variant_image_url) VALUES (?, ?, ?, ?, ?, ?)";
      
       // 生成されたIDを取得するために KeyHolder を使用
       KeyHolder keyHolder = new GeneratedKeyHolder();
       jdbcTemplate.update(connection -> {
           PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
           ps.setInt(1, variant.getProductId());
           ps.setString(2, variant.getSizeOrColor());
           ps.setInt(3, variant.getPrice());
           ps.setInt(4, variant.getStock());
           // litl が数値型であることを想定し setInt に変更[cite: 3]
           ps.setInt(5, variant.getLitl());
           ps.setString(6, variant.getVariantImageUrl());
           return ps;
       }, keyHolder);
      
       return keyHolder.getKey().intValue();
   }
}


