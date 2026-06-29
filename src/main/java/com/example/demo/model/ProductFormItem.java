package com.example.demo.model;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class ProductFormItem {
    // ■ 1. 商品の基本情報
    private Integer productId;
    private String name;
    private String kinds;
    private String base;
    private String hard;
    private String ken;
    private String description;
    
    // 📸 サブ画像関連のフィールド（複数管理用）
    private List<ProductImage> productImages = new ArrayList<>(); // ★ここで初期化することでエラーを防止
    private List<MultipartFile> subImageFiles;                    // ★一括アップロード受け取り用

    // ■ 2. 一覧表示（findJoinedAll）で使うためのフラットなフィールド群
    private Integer variantId;
    private String sizeOrColor;
    private Integer price;
    private Integer stock;
    private Integer litl;

    // ■ 3. 一括登録（フォーム受け取り用）の親子構造リスト
    private List<VariantInput> variants;

    // デフォルトコンストラクタ
    public ProductFormItem() {}

    // --- 内包するバリエーション専用のクラス ---
    public static class VariantInput {
        private Integer variantId;
        private String sizeOrColor;
        private Integer price;
        private Integer stock;
        private Integer litl;
        private Integer stockAdjustment;
        
        // 📸 メイン画像（バリエーション用）のフィールド
        private String variantImageUrl;     // 現在のメイン画像パス用
        private String existingImageUrl;    // JSPのhiddenから届く既存パス用
        private MultipartFile mainImageFile; // 🔄 変更または新規追加用ファイル

        // ゲッター・セッター
        public Integer getVariantId() { return variantId; }
        public void setVariantId(Integer variantId) { this.variantId = variantId; }
        public String getSizeOrColor() { return sizeOrColor; }
        public void setSizeOrColor(String sizeOrColor) { this.sizeOrColor = sizeOrColor; }
        public Integer getPrice() { return price; }
        public void setPrice(Integer price) { this.price = price; }
        public Integer getStock() { return stock; }
        public void setStock(Integer stock) { this.stock = stock; }
        public Integer getLitl() { return litl; }
        public void setLitl(Integer litl) { this.litl = litl; }
        public Integer getStockAdjustment() { return stockAdjustment; }
        public void setStockAdjustment(Integer stockAdjustment) { this.stockAdjustment = stockAdjustment; }
        public MultipartFile getMainImageFile() { return mainImageFile; }
        public void setMainImageFile(MultipartFile mainImageFile) { this.mainImageFile = mainImageFile; }
        
        public String getVariantImageUrl() { return variantImageUrl; }
        public void setVariantImageUrl(String variantImageUrl) { this.variantImageUrl = variantImageUrl; }
        public String getExistingImageUrl() { return existingImageUrl; }
        public void setExistingImageUrl(String existingImageUrl) { this.existingImageUrl = existingImageUrl; }
    }

    // --- 商品基本情報のゲッター・セッター ---
    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getKinds() { return kinds; }
    public void setKinds(String kinds) { this.kinds = kinds; }
    public String getBase() { return base; }
    public void setBase(String base) { this.base = base; }
    public String getHard() { return hard; }
    public void setHard(String hard) { this.hard = hard; }
    public String getKen() { return ken; }
    public void setKen(String ken) { this.ken = ken; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    // サブ画像関連（複数受取対応）のゲッター・セッター
    public List<ProductImage> getProductImages() { return productImages; }
    public void setProductImages(List<ProductImage> productImages) { this.productImages = productImages; }
    public List<MultipartFile> getSubImageFiles() { return subImageFiles; }
    public void setSubImageFiles(List<MultipartFile> subImageFiles) { this.subImageFiles = subImageFiles; }
    
    public List<VariantInput> getVariants() { return variants; }
    public void setVariants(List<VariantInput> variants) { this.variants = variants; }

    // --- 一覧表示用の通常のゲッター・セッター ---
    public Integer getVariantId() { return variantId; }
    public void setVariantId(Integer variantId) { this.variantId = variantId; }
    public String getSizeOrColor() { return sizeOrColor; }
    public void setSizeOrColor(String sizeOrColor) { this.sizeOrColor = sizeOrColor; }
    public Integer getPrice() { return price; }
    public void setPrice(Integer price) { this.price = price; }
    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }
    public Integer getLitl() { return litl; }
    public void setLitl(Integer litl) { this.litl = litl; }
    
 // 💡 コントローラー側の既存エラー（image_6fef1a.png）を解消するための互換用メソッド
    public MultipartFile getSubImageFile() {
        if (this.subImageFiles != null && !this.subImageFiles.isEmpty()) {
            return this.subImageFiles.get(0); // 複数あるうちの1番目のファイルを返す
        }
        return null;
    }

    public void setSubImageFile(MultipartFile subImageFile) {
        if (subImageFile != null) {
            if (this.subImageFiles == new java.util.ArrayList<MultipartFile>()) {
                this.subImageFiles = new java.util.ArrayList<>();
            }
            this.subImageFiles.clear();
            this.subImageFiles.add(subImageFile); // リストに格納する
        }
    }
 // 💡 コントローラー側の既存エラー（setSubImageUrl）を解消するための互換用メソッド
    public String getSubImageUrl() {
        if (this.productImages != null && !this.productImages.isEmpty()) {
            return this.productImages.get(0).getImageUrl(); // 1枚目の画像パスを返す
        }
        return null;
    }

    public void setSubImageUrl(String subImageUrl) {
        if (subImageUrl != null && !subImageUrl.isEmpty()) {
            if (this.productImages == null) {
                this.productImages = new java.util.ArrayList<>();
            }
            // すでに要素がある場合は1枚目を更新、ない場合は新しく追加
            if (!this.productImages.isEmpty()) {
                this.productImages.get(0).setImageUrl(subImageUrl);
            } else {
                ProductImage img = new ProductImage();
                img.setImageUrl(subImageUrl);
                this.productImages.add(img);
            }
        }
    }
 // 💡 コントローラー側の既存エラー（isDeleteSubImage）を解消するための互換用フィールドとメソッド
    private boolean deleteSubImage;

    public boolean isDeleteSubImage() {
        return deleteSubImage;
    }

    public void setDeleteSubImage(boolean deleteSubImage) {
        this.deleteSubImage = deleteSubImage;
    }
}

