package com.example.demo.dao;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.model.IndexCampaignBanner;
@Repository
public class IndexCampaignBannerDAO {
   @Autowired
   private JdbcTemplate jdbcTemplate;
   public List<IndexCampaignBanner> findAll() {
       String sql = """
           SELECT id, title, image_url, link_url, start_at, end_at, sort_order
           FROM campaign_banners
           ORDER BY
               CASE WHEN end_at < CURRENT_TIMESTAMP THEN 1 ELSE 0 END ASC,
               CASE WHEN end_at < CURRENT_TIMESTAMP THEN id END DESC,
               sort_order ASC
           """;
       return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(IndexCampaignBanner.class));
   }
   // 表示用：現在日時が開始日時〜終了日時の範囲内のバナーだけ取得
   public List<IndexCampaignBanner> findActiveBanners() {
       String sql = """
           SELECT id, title, image_url, link_url, start_at, end_at, sort_order
           FROM campaign_banners
           WHERE
               (start_at IS NULL OR start_at <= CURRENT_TIMESTAMP)
               AND
               (end_at IS NULL OR end_at >= CURRENT_TIMESTAMP)
           ORDER BY sort_order ASC, id DESC
           """;
       return jdbcTemplate.query(
           sql,
           new BeanPropertyRowMapper<>(IndexCampaignBanner.class)
       );
   }
   // キャンペーン詳細ページ用：管理画面に登録されているURLか確認
   public IndexCampaignBanner findByLinkUrl(String linkUrl) {
       String sql = """
           SELECT id, title, image_url, link_url, start_at, end_at, sort_order
           FROM campaign_banners
           WHERE link_url = ?
           LIMIT 1
           """;
       try {
           return jdbcTemplate.queryForObject(
               sql,
               new BeanPropertyRowMapper<>(IndexCampaignBanner.class),
               linkUrl
           );
       } catch (Exception e) {
           return null;
       }
   }
   public IndexCampaignBanner findById(int id) {
       return jdbcTemplate.queryForObject(
           "SELECT * FROM campaign_banners WHERE id = ?",
           new BeanPropertyRowMapper<>(IndexCampaignBanner.class),
           id
       );
   }
   public void insert(IndexCampaignBanner c) {
       // 同じsort_orderが既に存在すれば、それ以降を+1してずらす
       jdbcTemplate.update(
           "UPDATE campaign_banners SET sort_order = sort_order + 1 WHERE sort_order >= ?",
           c.getSortOrder()
       );
       String sql = """
           INSERT INTO campaign_banners
               (title, image_url, link_url, start_at, end_at, sort_order)
           VALUES (?, ?, ?, ?, ?, ?)
           """;
       jdbcTemplate.update(
           sql,
           c.getTitle(),
           c.getImageUrl(),
           c.getLinkUrl(),
           c.getStartAt(),
           c.getEndAt(),
           c.getSortOrder()
       );
   }
   public void update(IndexCampaignBanner c) {
       String sql = """
           UPDATE campaign_banners
           SET title = ?,
               image_url = ?,
               link_url = ?,
               start_at = ?,
               end_at = ?,
               sort_order = ?
           WHERE id = ?
           """;
       jdbcTemplate.update(
           sql,
           c.getTitle(),
           c.getImageUrl(),
           c.getLinkUrl(),
           c.getStartAt(),
           c.getEndAt(),
           c.getSortOrder(),
           c.getId()
       );
   }
   public void delete(int id) {
       jdbcTemplate.update(
           "DELETE FROM campaign_banners WHERE id = ?",
           id
       );
   }
   public void swapSortOrder(int id1, int id2) {
       Integer o1 = jdbcTemplate.queryForObject(
           "SELECT sort_order FROM campaign_banners WHERE id = ?",
           Integer.class,
           id1
       );
       Integer o2 = jdbcTemplate.queryForObject(
           "SELECT sort_order FROM campaign_banners WHERE id = ?",
           Integer.class,
           id2
       );
       jdbcTemplate.update(
           "UPDATE campaign_banners SET sort_order = ? WHERE id = ?",
           o2,
           id1
       );
       jdbcTemplate.update(
           "UPDATE campaign_banners SET sort_order = ? WHERE id = ?",
           o1,
           id2
       );
   }
}

