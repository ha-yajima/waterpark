package com.example.demo.dao;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.demo.model.IndexCampaignBanner;

@Repository
public class IndexCampaignBannerDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<IndexCampaignBanner> findAll() {

        String sql = """
            SELECT
                id,
                title,
                image_url,
                link_url,
                start_at,
                end_at,
                sort_order
            FROM campaign_banners
            ORDER BY sort_order ASC
            """;

        return jdbcTemplate.query(sql, (rs, rowNum) -> {

            LocalDateTime startAt = null;
            if (rs.getTimestamp("start_at") != null) {
                startAt = rs.getTimestamp("start_at").toLocalDateTime();
            }

            LocalDateTime endAt = null;
            if (rs.getTimestamp("end_at") != null) {
                endAt = rs.getTimestamp("end_at").toLocalDateTime();
            }

            IndexCampaignBanner banner = new IndexCampaignBanner();

            banner.setId(rs.getInt("id"));
            banner.setTitle(rs.getString("title"));
            banner.setImageUrl(rs.getString("image_url"));
            banner.setLinkUrl(rs.getString("link_url"));
            banner.setStartAt(startAt);
            banner.setEndAt(endAt);
            banner.setSortOrder(rs.getInt("sort_order"));

            return banner;
        });
    }
}

