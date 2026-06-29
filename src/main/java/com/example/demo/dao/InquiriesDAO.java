package com.example.demo.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.model.Inquiry;

@Repository
public class InquiriesDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 💡 問い合わせデータの新規登録
    public void insert(Inquiry inquiry) {
        String sql = "INSERT INTO inquiries ("
                   + "type, email, message, image_url, status, created_at"
                   + ") VALUES (?, ?, ?, ?, '未対応', NOW())";

        jdbcTemplate.update(sql,
            inquiry.getType(),
            inquiry.getEmail(),
            inquiry.getMessage(),
            inquiry.getImageUrl() // ※今回は画像なしならnullが流れます
        );
    }
     // ➕ 1. お問い合わせ一覧の取得（最新のものが上に来るように降順で取得）
        public List<Inquiry> findAll() {
            String sql = "SELECT id, type, email, message, image_url, status, created_at "
                       + "FROM inquiries ORDER BY created_at DESC";
            return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Inquiry.class));
        }

        // ➕ 2. ステータスの更新（「未対応」→「対応中」→「対応済み」など）
        public void updateStatus(int id, String status) {
            String sql = "UPDATE inquiries SET status = ? WHERE id = ?";
            jdbcTemplate.update(sql, status, id);
        }

        // ➕ 3. 特定の問い合わせを1件取得（詳細確認用や、個別返信画面用）
        public Inquiry findById(int id) {
            String sql = "SELECT id, type, email, message, image_url, status, created_at "
                       + "FROM inquiries WHERE id = ?";
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Inquiry.class), id);
        }
        
        // ➕ ページ指定でお問い合わせ一覧を取得（1ページ20件など）
        public List<Inquiry> findPage(int limit, int offset) {
            String sql = "SELECT id, type, email, message, image_url, status, created_at "
                       + "FROM inquiries ORDER BY created_at DESC LIMIT ? OFFSET ?";
            return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Inquiry.class), limit, offset);
        }

        // ➕ 全件数を取得（ページ数を計算するために必要）
        public int countAll() {
            String sql = "SELECT COUNT(*) FROM inquiries";
            return jdbcTemplate.queryForObject(sql, Integer.class);
        }
        
}
