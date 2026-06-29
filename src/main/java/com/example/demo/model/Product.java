package com.example.demo.model;
import java.time.LocalDateTime;
public class Product {
   private Integer id;
   private String name;
   private String description;
   private LocalDateTime createdAt;
   private String hard;           // 例: 硬水、軟水
   private String ken;            // 岐阜県/東京都/大阪府/北海道
   private String kinds;          // ミネラル/スパークリング/蒸留
   private String base;           // 地下水・温泉水
   private Boolean isRecommended; // おすすめ表示フラグ
   private Integer rank;          // ランキング順位
   private String subImage;
   private String variantImageUrl;
   // デフォルトコンストラクタ
   public Product() {}
   // ゲッター・セッター
   public Integer getId() { return id; }
   public void setId(Integer id) { this.id = id; }
   public String getName() { return name; }
   public void setName(String name) { this.name = name; }
   public String getDescription() { return description; }
   public void setDescription(String description) { this.description = description; }
   public LocalDateTime getCreatedAt() { return createdAt; }
   public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
   public String getHard() { return hard; }
   public void setHard(String hard) { this.hard = hard; }
   public String getKen() { return ken; }
   public void setKen(String ken) { this.ken = ken; }
   public String getKinds() { return kinds; }
   public void setKinds(String kinds) { this.kinds = kinds; }
   public String getBase() { return base; }
   public void setBase(String base) { this.base = base; }
   public Boolean getIsRecommended() { return isRecommended; }
   public void setIsRecommended(Boolean isRecommended) { this.isRecommended = isRecommended; }
   public Integer getRank() { return rank; }
   public void setRank(Integer rank) { this.rank = rank; }
   public String getSubImage() { return subImage; }
   public void setSubImage(String subImage) { this.subImage = subImage; }
   public String getVariantImageUrl() { return variantImageUrl; }
   public void setVariantImageUrl(String variantImageUrl) { this.variantImageUrl = variantImageUrl; }
}


