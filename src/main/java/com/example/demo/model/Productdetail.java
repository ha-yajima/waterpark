package com.example.demo.model;

import lombok.Data;

@Data
public class Productdetail {
    private int id;
    private String name;
    private String description;
    private String imageUrl;
    private int price;
    private int stock;
    private String ken;
    private String hard;
    private String kinds;
    private String base;

    // これを追加
    public String getFixedImageUrl() {
        if (imageUrl == null || imageUrl.isEmpty()) {
            return "/images/noimage.png";
        }

        if (imageUrl.startsWith("http") || imageUrl.startsWith("/")) {
            return imageUrl;
        }

        return "/" + imageUrl;
    }
}