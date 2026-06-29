package com.example.demo.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class IndexCampaignBanner implements Serializable {
    private int id;
    private String title;
    private String imageUrl;
    private String linkUrl;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private int sortOrder;

    public IndexCampaignBanner() {
    }

    public IndexCampaignBanner(int id, String title, String imageUrl, String linkUrl,
                               LocalDateTime startAt, LocalDateTime endAt, int sortOrder) {
        this.id = id;
        this.title = title;
        this.imageUrl = imageUrl;
        this.linkUrl = linkUrl;
        this.startAt = startAt;
        this.endAt = endAt;
        this.sortOrder = sortOrder;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getLinkUrl() { return linkUrl; }
    public void setLinkUrl(String linkUrl) { this.linkUrl = linkUrl; }

    public LocalDateTime getStartAt() { return startAt; }
    public void setStartAt(LocalDateTime startAt) { this.startAt = startAt; }

    public LocalDateTime getEndAt() { return endAt; }
    public void setEndAt(LocalDateTime endAt) { this.endAt = endAt; }

    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }
}

