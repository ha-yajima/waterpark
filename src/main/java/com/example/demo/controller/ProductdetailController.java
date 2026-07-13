package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dao.ProductdetailDAO;
import com.example.demo.model.Productdetail;

@Controller
public class ProductdetailController {

    @Autowired
    private ProductdetailDAO productsDAO;

    // Python側の関連商品API（IndexControllerと同じホスト・ポート）
    private static final String RELATED_PRODUCTS_URL = "http://127.0.0.1:8000/api/related_products?id=";

    /**
     * 商品詳細ページを表示する
     */
    @GetMapping("/product")
 // int を Integer に変更し、required = false を追加
	 public String showProductDetail(@RequestParam(name = "id", required = false) Integer id, Model model) {
	     
	     // idがnull(渡ってこない)または0以下の場合は、トップページへ逃がす
	     if (id == null || id <= 0) {
	         return "redirect:/";
	     }
	
	     Productdetail product = productsDAO.findById(id);
	     
	     // DBに該当IDがない場合もトップへ
	     if (product == null) {
	         return "redirect:/";
	     }

        model.addAttribute("product", product);
        model.addAttribute("images", productsDAO.findImagesByProductId(id));
        model.addAttribute("variants", productsDAO.findVariantsByProductId(id));
        model.addAttribute("variantImages", productsDAO.findVariantImagesByProductId(id));

        // 関連商品：まずPythonのAPIをサーバー側から呼び、失敗または0件ならDBからランダムに補う
        List<Map<String, Object>> relatedProducts = fetchRelatedProductsFromPython(id);
        if (relatedProducts == null || relatedProducts.isEmpty()) {
            relatedProducts = productsDAO.findRelatedProducts(id);
        }
        model.addAttribute("relatedProducts", relatedProducts);

        return "product-detail";
    }

    /**
     * Pythonの関連商品APIをサーバー側から呼び出す。
     * 失敗した場合はnullを返し、呼び出し元でDBフォールバックさせる。
     */
    private List<Map<String, Object>> fetchRelatedProductsFromPython(int id) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            Map<String, Object> response = restTemplate.getForObject(RELATED_PRODUCTS_URL + id, Map.class);

            if (response != null && response.containsKey("relatedProducts")) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> raw = (List<Map<String, Object>>) response.get("relatedProducts");
                return normalizeRelatedProducts(raw);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * PythonのJSON（image_url等のsnake_case）を、
     * DB取得結果（imageUrl等のcamelCase）と同じキー名に揃える。
     * JSP側は出所を意識せず同じ${r.imageUrl}等で描画できるようにするため。
     */
    private List<Map<String, Object>> normalizeRelatedProducts(List<Map<String, Object>> raw) {
        List<Map<String, Object>> normalized = new ArrayList<>();

        if (raw == null) {
            return normalized;
        }

        for (Map<String, Object> item : raw) {
            Map<String, Object> n = new HashMap<>();
            n.put("id", item.get("id"));
            n.put("name", item.get("name"));
            n.put("imageUrl", item.get("image_url"));
            n.put("price", item.get("price"));
            normalized.add(n);
        }

        return normalized;
    }
}

