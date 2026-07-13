package com.example.demo.dao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.model.Users;

@Repository
public class UsersDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ログイン確認（退会済みユーザーは除外）
    public Users findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ? AND is_withdrawn = FALSE";
        try {
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Users.class), email);
        } catch (EmptyResultDataAccessException e) {
            return null; // 対象のメールアドレスが存在しない、または退会済みの場合
        }
    }

    // 会員登録（新規ユーザー追加）
    public void insert(Users user) {
        String sql = "INSERT INTO users ("
                   + "last_name, first_name, last_name_kana, first_name_kana, "
                   + "email, password, phone_number, postal_code, "
                   + "prefecture, address1, address2, created_at"
                   + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        
        jdbcTemplate.update(sql, 
            user.getLastName(), 
            user.getFirstName(), 
            user.getLastNameKana(), 
            user.getFirstNameKana(), 
            user.getEmail(), 
            user.getPassword(),
            user.getPhoneNumber(), 
            user.getPostalCode(), 
            user.getPrefecture(), 
            user.getAddress1(), 
            user.getAddress2()
        );
    }

    // 会員情報変更（データ更新）
    public void update(Users user) {
        String sql = "UPDATE users SET "
                   + "last_name = ?, first_name = ?, last_name_kana = ?, first_name_kana = ?, "
                   + "email = ?, phone_number = ?, postal_code = ?, "
                   + "prefecture = ?, address1 = ?, address2 = ? "
                   + "WHERE id = ?";
        
        jdbcTemplate.update(sql, 
            user.getLastName(), 
            user.getFirstName(), 
            user.getLastNameKana(), 
            user.getFirstNameKana(), 
            user.getEmail(), 
            user.getPhoneNumber(), 
            user.getPostalCode(), 
            user.getPrefecture(), 
            user.getAddress1(), 
            user.getAddress2(), 
            user.getId()
        );
    }
    
    // 退会処理（論理削除：物理削除は行わない）
    public void delete(int id) {
        String sql = "UPDATE users SET is_withdrawn = TRUE, withdrawn_at = NOW() WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }
}