package com.example.demo.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class IndexNews implements Serializable {
    private int id;
    private String title;
    private String content;
    private LocalDateTime publishedAt;

    public IndexNews() {
    }

    public IndexNews(int id, String title, String content, LocalDateTime publishedAt) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.publishedAt = publishedAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public LocalDateTime getPublishedAt() { return publishedAt; }
    public void setPublishedAt(LocalDateTime publishedAt) { this.publishedAt = publishedAt; }
}

