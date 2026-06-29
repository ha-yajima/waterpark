package com.example.demo.model;

public class ProductVariant {
    private Integer id;
    private Integer productId;      // 外部キー(商品ID)
    private String sizeOrColor;    // 種類（サイズ・色）
    private Integer price;          // 単価
    private String variantImageUrl; // 種類専用画像URL
    private Integer stock;          // 在庫数
    private Integer litl;           // 250ml/500ml など

    // デフォルトコンストラクタ
    public ProductVariant() {}

    // ゲッター・セッター
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }

    public String getSizeOrColor() { return sizeOrColor; }
    public void setSizeOrColor(String sizeOrColor) { this.sizeOrColor = sizeOrColor; }

    public Integer getPrice() { return price; }
    public void setPrice(Integer price) { this.price = price; }

    public String getVariantImageUrl() { return variantImageUrl; }
    public void setVariantImageUrl(String variantImageUrl) { this.variantImageUrl = variantImageUrl; }

    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }

    public Integer getLitl() { return litl; }
    public void setLitl(Integer litl) { this.litl = litl; }
}