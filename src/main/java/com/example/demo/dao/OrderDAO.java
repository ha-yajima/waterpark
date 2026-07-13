package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class OrderDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 一覧画面用：注文・配送先・商品・明細を結合して取得
    public List<Map<String, Object>> findPage(String status, int limit, int offset) {
        String sql = "SELECT o.id, o.order_date AS purchase_date, o.status, " +
                     "p.name AS product_name, od.quantity, d.last_name, d.first_name " +
                     "FROM orders o " +
                     "JOIN delivery d ON o.delivery_id = d.id " +
                     "JOIN order_details od ON o.id = od.order_id " +
                     "JOIN product_variants pv ON od.variant_id = pv.id " +
                     "JOIN products p ON pv.product_id = p.id ";
        
        if (status != null && !status.isEmpty()) {
            sql += "WHERE o.status = ? ";
        }
        sql += "ORDER BY o.order_date DESC LIMIT ? OFFSET ?";
        
        return (status != null && !status.isEmpty()) 
                ? jdbcTemplate.queryForList(sql, status, limit, offset)
                : jdbcTemplate.queryForList(sql, limit, offset);
    }

    public int countAll(String status) {
        String sql = "SELECT COUNT(*) FROM orders ";
        if (status != null && !status.isEmpty()) {
            sql += "WHERE status = ?";
            return jdbcTemplate.queryForObject(sql, Integer.class, status);
        }
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }

    // 詳細画面用：住所などの配送先情報もすべて取得
    public Map<String, Object> getOrderDetail(int orderId) {
        // d.address を d.address1, d.address2 に変更
        String sql = "SELECT o.id, o.order_date AS purchase_date, o.status, " +
                     "d.last_name, d.first_name, d.postal_code, d.prefecture, d.address1, d.address2 " +
                     "FROM orders o JOIN delivery d ON o.delivery_id = d.id WHERE o.id = ?";
        return jdbcTemplate.queryForMap(sql, orderId);
    }

    public List<Map<String, Object>> getOrderItems(int orderId) {
        String sql = "SELECT p.name AS product_name, od.quantity, od.sum_price " +
                     "FROM order_details od " +
                     "JOIN product_variants pv ON od.variant_id = pv.id " +
                     "JOIN products p ON pv.product_id = p.id " +
                     "WHERE od.order_id = ?";
        return jdbcTemplate.queryForList(sql, orderId);
    }

    public void updateStatus(int orderId, String status) {
        jdbcTemplate.update("UPDATE orders SET status = ? WHERE id = ?", status, orderId);
    }
    
    
}


