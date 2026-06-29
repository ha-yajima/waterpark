package com.example.waterpark.entity;

import lombok.Data;

@Data
public class Productdetail {
    private int id;
    private String name;
    private String description;
    private String imageUrl;
    private int price;
    
    // ★ここに stock を追加！これで getStock() が使えるようになり赤線が消えます
    private int stock;
    private String ken;
    private String hard;
    private String kinds;
    private String base;
}