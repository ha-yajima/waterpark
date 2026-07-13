package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.dao.ProductDAO;
import com.example.demo.dao.ProductVariantDAO;
import com.example.demo.model.Product;
import com.example.demo.model.ProductFormItem;
import com.example.demo.model.ProductImage;
import com.example.demo.model.ProductVariant;

import jakarta.servlet.ServletContext;

@Controller
public class AdminProductController {

	@Autowired
	private ProductDAO productDAO;

    @Autowired
    private ProductVariantDAO productVariantDAO;

    // 🌐 サーバーの実行中のパスを動的に取得するためにサーブレットコンテキストを注入
    @Autowired
    private ServletContext servletContext;

    // 1. 新規登録 or 変更処理 (POST)
    @PostMapping("/admin/product/save")
    public String saveProduct(
            @ModelAttribute ProductFormItem form,
            @RequestParam(value = "subImageFiles", required = false) MultipartFile[] subImageFiles) { 
    	
    	if (form.getVariants() != null) {
            for (ProductFormItem.VariantInput v : form.getVariants()) {
                System.out.println("DEBUG: 受信したID=" + v.getVariantId() + ", 画像ファイル=" + (v.getMainImageFile() != null ? v.getMainImageFile().getOriginalFilename() : "なし"));
            }
        }
        
        System.out.println("====== 📥 送信データ確認 ======");
        System.out.println("商品ID (productId): " + form.getProductId()); 
        System.out.println("商品名: " + form.getName());
        System.out.println("==============================");

        // --- 📝 1. 親商品（Product）のオブジェクト作成 ---
        Product product = new Product();
        product.setName(form.getName());
        product.setDescription(form.getDescription());
        product.setHard(form.getHard());
        product.setKen(form.getKen());
        product.setKinds(form.getKinds());
        product.setBase(form.getBase());
        
        if (form.getProductId() != null && form.getProductId() > 0) {
            
            // ==========================================
            // ■🔄【変更（UPDATE）モード】の処理
            // ==========================================
            product.setId(form.getProductId()); 
            productDAO.update(product); // 親商品を更新
            System.out.println("🔄 既存の商品情報を更新しました。ID: " + form.getProductId());

            // 📸 サブ写真（product_images）の変更・削除処理
            if (form.isDeleteSubImage()) {
                productDAO.deleteSubImagesByProductId(form.getProductId());
                System.out.println("🗑️ product_images からサブ写真を削除しました。");
            } else if (subImageFiles != null && subImageFiles.length > 0 && !subImageFiles[0].isEmpty()) {
                productDAO.deleteSubImagesByProductId(form.getProductId());
                
                List<String> savedFileNames = new ArrayList<>();
                for (MultipartFile file : subImageFiles) {
                    if (!file.isEmpty()) {
                    	savedFileNames.add(saveFile(file, "product"));
                    }
                }
                productDAO.insertSubImages(form.getProductId(), savedFileNames);
                System.out.println("📸 変更モード：新しいサブ写真を " + savedFileNames.size() + " 枚登録しました。");
            }

            // バリエーションを更新（★ここに在庫数増減＆履歴保存ロジックを追加）
            if (form.getVariants() != null) {
                for (ProductFormItem.VariantInput vInput : form.getVariants()) {
                    if (vInput.getVariantId() == null) {
                        continue; 
                    }
                    
                    // 📦【在庫の増減 ＆ stock_histories への保存】
                    // 右側の「増やしたい個数（stockAdjustment）」が入力されているかチェック
                    if (vInput.getStockAdjustment() != null && vInput.getStockAdjustment() != 0) {
                        int currentStock = vInput.getStock() != null ? vInput.getStock() : 0;
                        int adjustment = vInput.getStockAdjustment();
                        int newStock = currentStock + adjustment; // 元の在庫に足し引きする
                        
                        // 1. バリエーションオブジェクトの在庫数を最新に上書き
                        vInput.setStock(newStock);
                        
                        // 2. stock_histories テーブルへ処理履歴をインサート (image_7ae68e.png の設計に準拠)
                        // 引数: variantId, type(処理区分), quantity(動いた数量), orderId(今回は手動なのでnull)
                        productDAO.insertStockHistory(vInput.getVariantId(), "手動調整", adjustment, null);
                        System.out.println("📝 在庫履歴を保存しました。VariantID: " + vInput.getVariantId() + " / 変動数: " + adjustment);
                    }
                    
                    String finalMainImageUrl = vInput.getExistingImageUrl(); 
                    if (vInput.getMainImageFile() != null && !vInput.getMainImageFile().isEmpty()) {
                    	finalMainImageUrl = saveFile(vInput.getMainImageFile(), "product");
                        System.out.println("🔄 バリエーションの新しいメイン画像をアップロードしました: " + finalMainImageUrl);
                    }
                    vInput.setVariantImageUrl(finalMainImageUrl); 
                    
                    productDAO.updateVariant(vInput);
                }
            }
            
        } else {
            
            // ==========================================
            // ■➕【新規登録（INSERT）モード】の処理
            // ==========================================
            int newProductId = productDAO.insert(product); 
            System.out.println("🔑 新規登録を実行。発行された商品ID: " + newProductId);

            // 📸 新規登録時の複数サブ写真を保存
            if (subImageFiles != null && subImageFiles.length > 0 && !subImageFiles[0].isEmpty()) {
                List<String> savedFileNames = new ArrayList<>();
                for (MultipartFile file : subImageFiles) {
                    if (!file.isEmpty()) {
                    	savedFileNames.add(saveFile(file, "product"));
                    }
                }
                productDAO.insertSubImages(newProductId, savedFileNames);
                System.out.println("📸 新規登録モード：サブ画像を " + savedFileNames.size() + " 枚保存しました。");
            }

            // バリエーションの一括登録
            if (form.getVariants() != null) {
                for (ProductFormItem.VariantInput vInput : form.getVariants()) {
                    if (vInput.getSizeOrColor() == null || vInput.getSizeOrColor().isEmpty()) {
                        continue; 
                    }

                    // 1. 画像パスの決定ロジック
                    String mainImagePath = vInput.getVariantImageUrl(); // まずはhiddenで送られてきた元のパスを入れる
                    if (vInput.getMainImageFile() != null && !vInput.getMainImageFile().isEmpty()) {
                        // 新しいファイルがあれば上書き
                        mainImagePath = saveFile(vInput.getMainImageFile(), "product");
                    }

                    // 2. バリエーションオブジェクトの作成
                    ProductVariant variant = new ProductVariant();
                    variant.setProductId(newProductId); // 新規・編集共通
                    variant.setSizeOrColor(vInput.getSizeOrColor());
                    variant.setPrice(vInput.getPrice());
                    variant.setStock(vInput.getStock());
                    variant.setLitl(vInput.getLitl());
                    variant.setVariantImageUrl(mainImagePath);

                    // 3. 既存（IDあり）か新規（IDなし）かで処理を分ける
                    if (vInput.getVariantId() != null && vInput.getVariantId() > 0) {
                        // 【更新】
                        variant.setId(vInput.getVariantId());
                        productVariantDAO.update(variant); // 更新用のDAOメソッドが必要です
                        System.out.println("🔄 バリエーションID " + vInput.getVariantId() + " を更新しました");
                    } else {
                        // 【新規追加】
                        int newVariantId = productVariantDAO.insert(variant);
                        
                        // 新規時のみ在庫履歴を残す
                        if (vInput.getStock() != null && vInput.getStock() > 0) {
                            productDAO.insertStockHistory(newVariantId, "追加登録", vInput.getStock(), null);
                        }
                        System.out.println("➕ 新規バリエーションを登録しました");
                    }
                }
            }
        }
        
        return "redirect:/admintop/main?mode=product";
    }

    // 2. 一覧から「変更」ボタンを押された時 (GET)
    @GetMapping("/admin/product/edit")
    public String editProductSetup(@RequestParam("productId") int productId, RedirectAttributes redirectAttributes) {

        Product product = productDAO.findById(productId);
        List<ProductFormItem.VariantInput> variants = productDAO.findVariantsByProductId(productId);

        // ★重要：ここでDBから取得した画像URLがちゃんと存在するかログで確認！
        if (variants != null) {
            for (ProductFormItem.VariantInput v : variants) {
                System.out.println("DEBUG: 取得したバリエーションID[" + v.getVariantId() + "] の画像URL: " + v.getVariantImageUrl());
            }
        }

        ProductFormItem editForm = new ProductFormItem();
        editForm.setProductId(product.getId());
        editForm.setName(product.getName());
        editForm.setDescription(product.getDescription());
        editForm.setHard(product.getHard());
        editForm.setKen(product.getKen());
        editForm.setKinds(product.getKinds());
        editForm.setBase(product.getBase());
        
        List<String> subImageUrls = productDAO.findSubImageUrlsByProductId(productId);
        List<ProductImage> productImages = new ArrayList<>();
        if (subImageUrls != null) {
            for (String url : subImageUrls) {
                ProductImage img = new ProductImage();
                img.setImageUrl(url);
                productImages.add(img);
            }
        }
        editForm.setProductImages(productImages); 
        
        editForm.setVariants(variants); 

        redirectAttributes.addFlashAttribute("isEdit", true);
        redirectAttributes.addFlashAttribute("productForm", editForm); 

        return "redirect:/admintop/main?mode=product";
    }

    // 3. 一覧から「削除」ボタンを押された時 (GET)
    @GetMapping("/admin/product/delete")
    public String deleteProduct(@RequestParam("productId") int productId) {
        System.out.println("====== 🗑️ 削除処理開始 ======");
        productDAO.deleteSubImagesByProductId(productId);
        productDAO.deleteVariantsByProductId(productId);
        productDAO.delete(productId);
        System.out.println("====== 🗑️ 削除処理完了 ======");
        return "redirect:/admintop/main?mode=product";
    }
    
 // 🛠️ プロジェクト内の webapp フォルダに直接保存する設定
    private String saveFile(MultipartFile file, String category) {
        try {
            if (file == null || file.isEmpty()) return null;
            
            String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            
            // 重要：Cドライブに「uploads/images」というフォルダを自分で作ってください
            String uploadDir = "C:/uploads/images/" + category + "/";
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            
            File dest = new File(dir, fileName);
            file.transferTo(dest);
            
            // ブラウザからアクセスするためのパス（/images/category/fileName になる）
            return "/images/" + category + "/" + fileName;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    
    // 4. 商品名での検索処理 (GET)
    @GetMapping("/admin/product/searchByName")
    public String searchProductByName(
            @RequestParam("name") String name,
            RedirectAttributes redirectAttributes) {
        
        List<ProductFormItem> searchResult = productDAO.findJoinedByName(name);
        
        for (ProductFormItem item : searchResult) {
            if (item.getProductId() != null) {
                List<String> subImageUrls = productDAO.findSubImageUrlsByProductId(item.getProductId());
                List<ProductImage> productImages = new ArrayList<>();
                if (subImageUrls != null) {
                    for (String url : subImageUrls) {
                        ProductImage img = new ProductImage();
                        img.setImageUrl(url);
                        productImages.add(img);
                    }
                }
                item.setProductImages(productImages);
            }
        }

        redirectAttributes.addFlashAttribute("productList", searchResult);
        redirectAttributes.addFlashAttribute("searchKeyword", name);

        return "redirect:/admintop/main?mode=product";
    }
    
    // 5. 検索窓に名前を入れて「検索」された時、その商品データを上のフォームにセットする (GET)
    @GetMapping("/admin/product/editOnSearch")
    public String editProductOnSearch(
            @RequestParam("name") String name,
            RedirectAttributes redirectAttributes) {
        
        Integer productId = productDAO.findIdByName(name);
        if (productId == null) {
            return "redirect:/admintop/main?mode=product";
        }

        Product product = productDAO.findById(productId);
        List<ProductFormItem.VariantInput> variants = productDAO.findVariantsByProductId(productId);

        ProductFormItem editForm = new ProductFormItem();
        editForm.setProductId(product.getId());
        editForm.setName(product.getName());
        editForm.setDescription(product.getDescription());
        editForm.setHard(product.getHard());
        editForm.setKen(product.getKen());
        editForm.setKinds(product.getKinds());
        editForm.setBase(product.getBase());
        
        List<String> subImageUrls = productDAO.findSubImageUrlsByProductId(productId);
        List<ProductImage> productImages = new ArrayList<>();
        if (subImageUrls != null) {
            for (String url : subImageUrls) {
                ProductImage img = new ProductImage();
                img.setImageUrl(url);
                productImages.add(img);
            }
        }
        editForm.setProductImages(productImages); 
        
        editForm.setVariants(variants);

        redirectAttributes.addFlashAttribute("isEdit", true);
        redirectAttributes.addFlashAttribute("productForm", editForm);

        return "redirect:/admintop/main?mode=product";
    }
}

