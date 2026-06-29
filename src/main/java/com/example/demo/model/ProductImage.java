package com.example.demo.model;
public class ProductImage {
   private Integer id;
   private Integer productId;
   private String imageUrl; // 仕様書のカラム名 image_url に対応
   private Integer isMain;
   private Integer sortOrder;
   // デフォルトコンストラクタ
   public ProductImage() {}
   // ゲッター・セッター
   public Integer getId() { return id; }
   public void setId(Integer id) { this.id = id; }
   public Integer getProductId() { return productId; }
   public void setProductId(Integer productId) { this.productId = productId; }
   public String getImageUrl() { return imageUrl; }
   public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
   public Integer getIsMain() { return isMain; }
   public void setIsMain(Integer isMain) { this.isMain = isMain; }
   public Integer getSortOrder() { return sortOrder; }
   public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }
}

