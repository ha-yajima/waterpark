package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class MypageDAO {
	@Autowired
    private JdbcTemplate jdbcTemplate;
	
	public List<Map<String, Object>> getOrderHistory(int userId) {
        String sql = "SELECT o.order_date, o.status, od.variant_id, od.quantity, od.sum_price " +
                     "FROM orders o " +
                     "JOIN order_details od ON o.id = od.order_id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.order_date DESC";
        
        List<Map<String, Object>> list = jdbcTemplate.queryForList(sql, userId);
        
        // ここで件数を確認するログを追加
        System.out.println("★取得した注文履歴の件数: " + list.size());
        
//        return jdbcTemplate.queryForList(sql, userId);

            
            return list;
        }
}

