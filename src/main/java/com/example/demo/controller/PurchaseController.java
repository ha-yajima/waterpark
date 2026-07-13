package com.example.demo.controller;

import java.time.LocalDate;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dao.ProductdetailDAO;
import com.example.demo.model.Productdetail;

import jakarta.servlet.http.HttpSession;

@Controller
public class PurchaseController {

	@Autowired
	private ProductdetailDAO productdetailDAO;
	
    @GetMapping("/purchase")
    public String purchase(
            @RequestParam int id,
            @RequestParam int variantId,
            @RequestParam int quantity,
            HttpSession session,
            Model model) {

        // ログインしていない場合
        if (session.getAttribute("loginUser") == null) {

            return "redirect:/auth/login?redirect=/purchase?id="
                    + id
                    + "%26variantId="
                    + variantId
                    + "%26quantity="
                    + quantity;
        }

     // ログイン中のユーザー情報
        model.addAttribute("user", session.getAttribute("loginUser"));

        // 商品情報を取得
        Productdetail product = productdetailDAO.findById(id);
        model.addAttribute("product", product);
        
     // 商品画像
        model.addAttribute("images", productdetailDAO.findImagesByProductId(id));

        // 選択されたバリエーション
        Map<String, Object> selectedVariant = productdetailDAO.findVariantById(variantId);
        model.addAttribute("selectedVariant", selectedVariant);

        // 購入数量
        model.addAttribute("buyQuantity", quantity);

        // お届け予定日（仮）
        LocalDate deliveryDate = LocalDate.now().plusDays(2);
        model.addAttribute("deliveryDate", deliveryDate);
        return "purchase";
    }

    @PostMapping("/purchase/confirm")
    public String confirmPurchase(
            @RequestParam Map<String, String> params,
            HttpSession session,
            Model model) {
    	
    	System.out.println("★受信したパラメータ一覧: " + params);

        int productId = Integer.parseInt(params.get("productId"));
        int variantId = Integer.parseInt(params.get("variantId"));
        int quantity = Integer.parseInt(params.get("quantity"));
        
        // 1. バリデーション前に共通データを取得
        Productdetail product = productdetailDAO.findById(productId);
        Map<String, Object> selectedVariant = productdetailDAO.findVariantById(variantId);
        LocalDate deliveryDate = LocalDate.now().plusDays(2);

        // 2. バリデーション失敗時の共通戻り値セット用メソッド（または処理）
        // 今回はシンプルに書きます
        String lastName = params.get("lastName");
        String firstName = params.get("firstName");

        if (lastName == null || firstName == null
                || !lastName.matches("^[ぁ-んァ-ヶー一-龯A-Za-zａ-ｚＡ-Ｚ]+$")
                || !firstName.matches("^[ぁ-んァ-ヶー一-龯A-Za-zａ-ｚＡ-Ｚ]+$")) {

            prepareModel(model, session, product, selectedVariant, quantity, deliveryDate,
                    "姓・名を正しく入力してください。");
            return "purchase";
        }
        
        String prefecture = params.get("prefecture");
        String address1 = params.get("address1");
        String address2 = params.get("address2");

        if (address2 == null) {
            address2 = "";
        }

        String address = prefecture + address1 + address2;

        if (!address.matches("^[0-9０-９ぁ-んァ-ヶー一-龯a-zA-Zａ-ｚＡ-Ｚ\\-－ー丁目番地号室\\s]+$")) {
            prepareModel(model, session, product, selectedVariant, quantity, deliveryDate, "住所を正しく入力してください。");
            return "purchase";
        }

        // 3. 在庫チェック
        int stock = ((Number) selectedVariant.get("stock")).intValue();
        if (quantity > stock) {
            prepareModel(model, session, product, selectedVariant, stock, deliveryDate, "在庫数を超えています。");
            return "purchase";
        }

        // 4. 正常時処理
        int price = ((Number) selectedVariant.get("price")).intValue();
        int sumPrice = price * quantity;
        params.put("sumPrice", String.valueOf(sumPrice));

        session.setAttribute("orderData", params);

        model.addAttribute("orderData", params);
        model.addAttribute("product", product);
        model.addAttribute("selectedVariant", selectedVariant);
        model.addAttribute("deliveryDate", deliveryDate);

        return "purchase-confirm";
    }
    // 冗長なコードをまとめるためのヘルパーメソッド
    private void prepareModel(Model model, HttpSession session, Productdetail product, Map<String, Object> variant, int qty, LocalDate date, String error) {
        model.addAttribute("error", error);
        model.addAttribute("user", session.getAttribute("loginUser"));
        model.addAttribute("product", product);
        model.addAttribute("selectedVariant", variant);
        model.addAttribute("buyQuantity", qty);
        model.addAttribute("deliveryDate", date);
        
        model.addAttribute("images", productdetailDAO.findImagesByProductId(product.getId()));
    }

    @PostMapping("/purchase/complete")
    public String completePurchase(HttpSession session, Model model) {
    	
    	
    	java.util.Enumeration<String> attrs = session.getAttributeNames();
        while (attrs.hasMoreElements()) {
            String key = attrs.nextElement();
            System.out.println("セッション内データ: " + key + " = " + session.getAttribute(key));
        }
        
        @SuppressWarnings("unchecked")
        Map<String, String> orderData = (Map<String, String>) session.getAttribute("orderData");
        
        if (orderData == null) {
            System.out.println("★エラー：orderDataがセッションにありません"); // ここ！
            return "redirect:/"; 
        }
        
        

     // ユーザー情報と注文情報を取得
        int userId = ((com.example.demo.model.Users) session.getAttribute("loginUser")).getId();
        int variantId = Integer.parseInt(orderData.get("variantId"));
        int quantity = Integer.parseInt(orderData.get("quantity"));
        int sumPrice = Integer.parseInt(orderData.get("sumPrice")); 
        
        int productId = Integer.parseInt(orderData.get("productId"));

        Productdetail product = productdetailDAO.findById(productId);
        Map<String, Object> selectedVariant = productdetailDAO.findVariantById(variantId);

        LocalDate deliveryDate = LocalDate.now().plusDays(2);
        
        model.addAttribute("product", product);
        model.addAttribute("selectedVariant", selectedVariant);
        model.addAttribute("orderData", orderData);
        model.addAttribute("deliveryDate", deliveryDate);
 
        // ★修正：DBから現在の単価(price)を取得する
        java.util.Map<String, Object> variant = productdetailDAO.findVariantById(variantId);
        int price = (int) variant.get("price");

        // 1. 在庫を減らす
        boolean success = productdetailDAO.reduceStock(variantId, quantity);
        if (!success) return "error";

     // 2. 配送先を保存
     int deliveryId = productdetailDAO.insertDelivery(orderData);

     // 3. 注文履歴を保存
     int orderId = productdetailDAO.insertOrder(userId, deliveryId);

     // 4. 注文詳細を保存
     productdetailDAO.insertOrderDetail(orderId, variantId, quantity, price, sumPrice);

        // 処理完了後、セッションをクリア
        session.removeAttribute("orderData");

        return "complete";
    }
}