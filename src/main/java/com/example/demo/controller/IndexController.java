package com.example.demo.controller;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dao.IndexCampaignBannerDAO;
import com.example.demo.dao.IndexNewsDAO;
import com.example.demo.dao.ProductDAO;
import com.example.demo.model.IndexCampaignBanner;
import com.example.demo.model.IndexNews;
@Controller
public class IndexController {
   @Autowired
   private IndexCampaignBannerDAO bannerDAO;
   @Autowired
   private IndexNewsDAO newsDAO;
   @Autowired
   private ProductDAO productDAO;
   @GetMapping("/")
   public String index(Model model) {
   	System.out.println("DEBUG: indexメソッド開始");
   	List<IndexCampaignBanner> bannerList = bannerDAO.findActiveBanners();
       List<IndexNews> newsList = newsDAO.findLatestNews();
       RestTemplate restTemplate = new RestTemplate();
       // 1. 💡 Python API からランキングデータを取得する処理
       String pythonUrl = "http://127.0.0.1:8000/recommendations/";
       List<Map<String, Object>> rankingProductList = new ArrayList<>();
       try {
           Map<String, Object> response = restTemplate.getForObject(pythonUrl, Map.class);
           if (response != null && response.containsKey("recommendations")) {
               rankingProductList = (List<Map<String, Object>>) response.get("recommendations");
               // 💡 各商品に詳細画面へのURLを付与
               addDetailUrls(rankingProductList);
           }
       } catch (Exception e) {
           e.printStackTrace();
       }
      
       // 2. 💡 おすすめ商品データの取得
       String featuredUrl = "http://127.0.0.1:8000/recommendations/featured/";
       List<Map<String, Object>> recommendedProductList = new ArrayList<>();
       try {
           Map<String, Object> response = restTemplate.getForObject(featuredUrl, Map.class);
           if (response != null && response.containsKey("recommendations")) {
               recommendedProductList = (List<Map<String, Object>>) response.get("recommendations");
               // 💡 各商品に詳細画面へのURLを付与
               addDetailUrls(recommendedProductList);
           }
       } catch (Exception e) {
           e.printStackTrace();
       }
      
       // 3. 💡 新着商品データの取得
       String newUrl = "http://127.0.0.1:8000/recommendations/new/";
       List<Map<String, Object>> newProductList = new ArrayList<>();
       try {
           Map<String, Object> response = restTemplate.getForObject(newUrl, Map.class);
           if (response != null && response.containsKey("new_arrivals")) {
               newProductList = (List<Map<String, Object>>) response.get("new_arrivals");
               // 💡 各商品に詳細画面へのURLを付与
               addDetailUrls(newProductList);
           }
       } catch (Exception e) {
           e.printStackTrace();
       }
       model.addAttribute("bannerList", bannerList);
       model.addAttribute("newsList", newsList);
      
       model.addAttribute("recommendedProductList", recommendedProductList);
       model.addAttribute("rankingProductList", rankingProductList);
       model.addAttribute("newProductList", newProductList);
      
       model.addAttribute("cartCount", 1);
       return "index";
   }
   /**
    * Pythonから取得した商品リストに、Java側の詳細画面URLを追加する共通メソッド
    */
   private void addDetailUrls(List<Map<String, Object>> productList) {
       if (productList == null) return;
       for (Map<String, Object> product : productList) {
       	
       	System.out.println("DEBUG: 受信データ詳細 -> " + product);
          
           // 1. IDを取得して detailUrl を作成（元の処理）
           Object idObj = product.get("id");
           if (idObj == null) {
               idObj = product.get("product_id");
           }
           if (idObj != null && !idObj.toString().trim().isEmpty()) {
               product.put("detailUrl", "http://localhost:8080/product?id=" + idObj.toString());
           } else {
               product.put("detailUrl", "http://localhost:8080/products");
           }
           // 2. ★追加：Pythonから来た image_url を処理して固定パスに変換
        // ★修正：画像がない場合のデフォルト対応を追加
           Object imgObj = product.get("image_url");
           String imgPath = (imgObj != null) ? imgObj.toString() : "";
           if (imgPath.isEmpty()) {
               // 画像URLが空ならデフォルト画像を指定
               product.put("fixedImageUrl", "/images/product/no_image.jpg");
           } else if (!imgPath.startsWith("/images/")) {
               // パスが正しくない場合（ファイル名のみの場合など）の補完
               product.put("fixedImageUrl", "/images/product/" + imgPath);
           } else {
               // 正しいパスが入っている場合はそのまま使う
               product.put("fixedImageUrl", imgPath);
           }
       }
   }
}

