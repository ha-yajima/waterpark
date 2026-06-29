package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dao.ProductdetailDAO;
import com.example.demo.entity.Productdetail;

@Controller
public class ProductdetailController {

    @Autowired
    private ProductdetailDAO productsDAO;
    
    /**
     * 商品詳細ページを表示する
     */
    @GetMapping("/product")
    public String showProductDetail(@RequestParam("id") int id, Model model) {
        Productdetail product = productsDAO.findById(id);
        
        if (product == null) {
            return "redirect:/";
        }

        // データベースから本物の画像一覧とバリエーション一覧を取得してモデルに詰める
        model.addAttribute("product", product);
        model.addAttribute("images", productsDAO.findImagesByProductId(id));
        model.addAttribute("variants", productsDAO.findVariantsByProductId(id));
        model.addAttribute(
        	    "variantImages",
        	    productsDAO.findVariantImagesByProductId(id)
        	);
        model.addAttribute(
        	    "relatedProducts",
        	    productsDAO.findRelatedProducts(id)
        	);
        
        return "product-detail";
    }
    
    /**
     * 購入手続きページを表示する
     * 詳細画面から送られてきた variantId（選んだ本数）と quantity（数量）を受け取る
     */
    @GetMapping("/purchase")
    public String showPurchasePage(@RequestParam("id") int id, 
                                   @RequestParam(value = "variantId", required = false) Integer variantId,
                                   @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                                   Model model) {
        
        Productdetail product = productsDAO.findById(id);
        if (product == null) {
            return "redirect:/";
        }

        // 選択されたバリエーションの取得（元の正しいfindByIdのままにします）
        var selectedVariant = productsDAO.findVariantById(variantId);
        
        // 配達予定日の計算（3日後）
        java.time.LocalDate deliveryDate = java.time.LocalDate.now().plusDays(3);
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("M月d日");

        model.addAttribute("product", product);
        model.addAttribute("selectedVariant", selectedVariant); // 選んだバリエーション情報（本数・価格）
        model.addAttribute("buyQuantity", quantity);             // 選んだセット数（数量）
        model.addAttribute("deliveryDate", deliveryDate.format(formatter));
        
        return "purchase";
    }

    /**
     * 注文を確定し、在庫を減らす処理
     */
    @PostMapping("/purchase/complete")
    public String completePurchase(@RequestParam(value = "productId", required = false) Integer productId,
                                   @RequestParam(value = "variantId", required = false) Integer variantId,
                                   @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                                   Model model) {
        
        // パラメータが空（null）の場合は安全にトップページへ流す
        if (productId == null || variantId == null) {
            return "redirect:/";
        }
        
        Productdetail product = productsDAO.findById(productId);
        if (product == null) {
            return "redirect:/";
        }
        
        // 実際の在庫変更処理（variantIdを指定して減らす！）
        boolean isSuccess = productsDAO.reduceStock(variantId, quantity);
        
        if (!isSuccess) {
            model.addAttribute("product", product);
            model.addAttribute("error", "申し訳ありません。在庫が不足しているか、タッチの差で売り切れてしまいました。");
            return "redirect:/purchase?id=" + productId + "&variantId=" + variantId;
        }
        
        model.addAttribute("product", product);
        model.addAttribute("buyQuantity", quantity);
        
        // 👈 complete.jsp を呼び出すために "complete" に修正
        return "complete";
    }
    
    /**
     * 注文完了画面を表示する処理（GET）
     */
    @GetMapping("/purchase/complete")
    public String showCompletePage() {
        // 👈 complete.jsp を呼び出すために "complete" に修正
        return "complete";
    }
    
    
    
}