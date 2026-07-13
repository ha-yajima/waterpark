package com.example.demo.controller;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dao.IndexCampaignBannerDAO;
import com.example.demo.dao.ProductDAO;
import com.example.demo.model.IndexCampaignBanner;
import com.example.demo.model.ProductFormItem;
@Controller
public class CampaignController {
   @Autowired
   private IndexCampaignBannerDAO bannerDAO;
   @Autowired
   private ProductDAO productDAO;
   // キャンペーン詳細ページ 共通
   @GetMapping("/campaign/{slug}")
   public String campaignDetail(
           @PathVariable String slug,
           Model model) {
       // slugに英数字とハイフン以外が含まれていたらTOPへ戻す
       if (!slug.matches("[a-zA-Z0-9\\-]+")) {
           return "redirect:/";
       }
       // キャンペーン情報をDBから取得
       IndexCampaignBanner campaign =
               bannerDAO.findByLinkUrl("/campaign/" + slug);
       // 該当するキャンペーンがなければTOPへ戻す
       if (campaign == null) {
           return "redirect:/";
       }
       /*
        * ランキング商品をPython APIから取得
        * Pythonが停止している場合はDAOから取得
        */
       List<ProductFormItem> rankingProducts =
               getRankingProducts();
       model.addAttribute("campaign", campaign);
       model.addAttribute("rankingProducts", rankingProducts);
       model.addAttribute("cartCount", 1);
       return "campaign/" + slug;
   }
   /**
    * Python APIからランキング商品を3件取得する。
    * Python APIに接続できない場合はDAOから取得する。
    */
   private List<ProductFormItem> getRankingProducts() {
       String pythonUrl =
               "http://127.0.0.1:8000/recommendations/?limit=3";
       List<ProductFormItem> productList = new ArrayList<>();
       try {
           RestTemplate restTemplate = new RestTemplate();
           Map<String, Object> response =
                   restTemplate.getForObject(pythonUrl, Map.class);
           // Python APIのレスポンスがない場合
           if (response == null
                   || !response.containsKey("recommendations")) {
               System.out.println(
                       "DEBUG: Python APIのレスポンスがありません。DAOへ切り替えます。"
               );
               return productDAO.findRankingCampaignProducts();
           }
           List<Map<String, Object>> pythonProducts =
                   (List<Map<String, Object>>)
                           response.get("recommendations");
           // Python APIの商品が0件の場合
           if (pythonProducts == null
                   || pythonProducts.isEmpty()) {
               System.out.println(
                       "DEBUG: Python APIの商品が0件です。DAOへ切り替えます。"
               );
               return productDAO.findRankingCampaignProducts();
           }
           // Pythonの商品データをProductFormItemへ変換
           for (Map<String, Object> item : pythonProducts) {
               ProductFormItem product =
                       new ProductFormItem();
               // 商品ID
               Object idObj = item.get("product_id");
               if (idObj == null) {
                   idObj = item.get("id");
               }
               product.setProductId(
                       toInt(idObj)
               );
               // 商品名
               Object nameObj = item.get("name");
               if (nameObj != null) {
                   product.setName(
                           nameObj.toString()
                   );
               }
               // 価格
               product.setPrice(
                       toInt(item.get("price"))
               );
               // 商品画像
               Object imageObj =
                       item.get("image_url");
               String imageUrl = "";
               if (imageObj != null) {
                   imageUrl = imageObj.toString();
               }
               product.setVariantImageUrl(
                       imageUrl
               );
               productList.add(product);
           }
           System.out.println(
                   "DEBUG: Python APIからランキング商品を取得しました。件数="
                           + productList.size()
           );
           return productList;
       } catch (Exception e) {
           System.out.println(
                   "DEBUG: Python APIに接続できませんでした。DAOへ切り替えます。"
           );
           System.out.println(
                   "DEBUG: URL = " + pythonUrl
           );
           System.out.println(
                   "DEBUG: エラー内容 = "
                           + e.getMessage()
           );
           return productDAO.findRankingCampaignProducts();
       }
   }
   /**
    * Pythonから受け取ったObject型の数値をint型に変換する。
    */
   private int toInt(Object value) {
       if (value == null) {
           return 0;
       }
       if (value instanceof Number) {
           return ((Number) value).intValue();
       }
       return Integer.parseInt(
               value.toString()
       );
   }
}

