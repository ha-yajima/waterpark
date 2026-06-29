package com.example.demo.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.model.IndexNews;

@Repository
public class IndexNewsDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 1. トップ画面用の最新3件取得
    public List<IndexNews> findLatestNews() {
        String sql = "SELECT id, title, content, published_at FROM news ORDER BY published_at DESC LIMIT 3";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(IndexNews.class));
    }

    // 2. 一覧用：ニュース全件取得
    public List<IndexNews> findAll() {
        String sql = "SELECT id, title, content, published_at FROM news ORDER BY published_at DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(IndexNews.class));
    }

    // 3. 編集用：IDで1件取得
    public IndexNews findById(int id) {
        String sql = "SELECT id, title, content, published_at FROM news WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(IndexNews.class), id);
    }

    // 4. 追加：新規登録
    public void insert(IndexNews news) {
        String sql = "INSERT INTO news (title, content, published_at) VALUES (?, ?, NOW())";
        jdbcTemplate.update(sql, news.getTitle(), news.getContent());
    }

    // 5. 更新：内容変更
    public void update(IndexNews news) {
        String sql = "UPDATE news SET title = ?, content = ? WHERE id = ?";
        jdbcTemplate.update(sql, news.getTitle(), news.getContent(), news.getId());
    }

    // 6. 削除
    public void delete(int id) {
        String sql = "DELETE FROM news WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }
}


