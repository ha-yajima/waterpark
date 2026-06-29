package com.example.demo.model;

import java.time.LocalDateTime;

public class Inquiry {
    private Integer id;
    private String type;
    private String email;
    private String message;
    private String imageUrl;
    private String status;
    private LocalDateTime createdAt;

    // ゲッター・セッター（Eclipseの自動生成機能などで作成してください）
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
