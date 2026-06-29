package com.example.demo.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.model.Campaign;

@Repository
public class CampaignDAO {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Campaign> findAll() {
        return jdbcTemplate.query("SELECT * FROM campaign_banners ORDER BY sort_order ASC", 
                                  new BeanPropertyRowMapper<>(Campaign.class));
    }
    public Campaign findById(int id) {
        return jdbcTemplate.queryForObject("SELECT * FROM campaign_banners WHERE id = ?", 
                                          new BeanPropertyRowMapper<>(Campaign.class), id);
    }
    public void update(Campaign c) {
        String sql = "UPDATE campaign_banners SET title=?, image_url=?, link_url=?, sort_order=? WHERE id=?";
        jdbcTemplate.update(sql, c.getTitle(), c.getImageUrl(), c.getLinkUrl(), c.getSortOrder(), c.getId());
    }
    public void delete(int id) {
        jdbcTemplate.update("DELETE FROM campaign_banners WHERE id = ?", id);
    }
}