package com.example.demo.controller;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dao.ProductDAO;
import com.example.demo.model.ProductFormItem;
@Controller
public class IndexProductController {
   @Autowired
   private ProductDAO productDAO;
   // 商品一覧ページを表示
   @GetMapping("/products")
   public String showProductList(
           @RequestParam(value = "minPrice", required = false) Integer minPrice,
           @RequestParam(value = "maxPrice", required = false) Integer maxPrice,
           @RequestParam(value = "sort", required = false) String sort,
           Model model) {
       List<ProductFormItem> productList;
       if ("new".equals(sort)) {
           // 新着商品をPython APIから20件取得
           productList = getPythonProducts(
                   "http://127.0.0.1:8000/recommendations/new/?limit=20",
                   "new_arrivals"
           );
       } else if ("recommended".equals(sort)) {
           // おすすめ商品をPython APIから20件取得
           productList = getPythonProducts(
                   "http://127.0.0.1:8000/recommendations/featured/?limit=20",
                   "recommendations"
           );
       } else if ("ranking".equals(sort)) {
           // ランキング商品をPython APIから20件取得
           productList = getPythonProducts(
                   "http://127.0.0.1:8000/recommendations/?limit=20",
                   "recommendations"
           );
       } else if (minPrice != null || maxPrice != null) {
           // 価格条件があるときだけDB検索
           productList = productDAO.findJoinedBySearchConditions(
                   null,
                   null,
                   null,
                   null,
                   minPrice,
                   maxPrice
           );
       } else {
           // 通常の商品一覧はDBから取得
           productList = productDAO.findJoinedAll();
       }
       model.addAttribute("productList", productList);
       model.addAttribute("minPrice", minPrice);
       model.addAttribute("maxPrice", maxPrice);
       model.addAttribute("sort", sort);
       return "products";
   }
   // キーワード検索・都道府県検索・硬度・種類・価格検索
   @GetMapping("/products/search")
   public String searchProducts(
           @RequestParam(value = "keyword", required = false) String keyword,
           @RequestParam(value = "prefecture", required = false) String prefecture,
           @RequestParam(value = "hardness", required = false) List<String> hardness,
           @RequestParam(value = "type", required = false) List<String> type,
           @RequestParam(value = "minPrice", required = false) Integer minPrice,
           @RequestParam(value = "maxPrice", required = false) Integer maxPrice,
           Model model) {
       // 検索系はDBから取得
       List<ProductFormItem> productList =
               productDAO.findJoinedBySearchConditions(
                       keyword,
                       prefecture,
                       hardness,
                       type,
                       minPrice,
                       maxPrice
               );
       model.addAttribute("productList", productList);
       model.addAttribute("keyword", keyword);
       model.addAttribute("prefecture", prefecture);
       model.addAttribute("hardness", hardness);
       model.addAttribute("type", type);
       model.addAttribute("minPrice", minPrice);
       model.addAttribute("maxPrice", maxPrice);
       return "products";
   }
   // Python APIから商品リストを取得する共通メソッド
   private List<ProductFormItem> getPythonProducts(String url, String listKey) {
       List<ProductFormItem> productList = new ArrayList<>();
       try {
           RestTemplate restTemplate = new RestTemplate();
           Map<String, Object> response =
                   restTemplate.getForObject(url, Map.class);
           if (response == null || !response.containsKey(listKey)) {
               return productList;
           }
           List<Map<String, Object>> pythonProducts =
                   (List<Map<String, Object>>) response.get(listKey);
           for (Map<String, Object> item : pythonProducts) {
               ProductFormItem product = new ProductFormItem();
               Object idObj = item.get("product_id");
               if (idObj == null) {
                   idObj = item.get("id");
               }
               product.setProductId(toInt(idObj));
               product.setName((String) item.get("name"));
               product.setPrice(toInt(item.get("price")));
               String imageUrl = "";
               Object imageObj = item.get("image_url");
               if (imageObj != null) {
                   imageUrl = imageObj.toString();
               }
               product.setVariantImageUrl(imageUrl);
               Object score = item.get("total_score");
               if (score != null) {
                   product.setBase("おすすめスコア：" + score.toString());
               } else {
                   product.setBase("Python取得商品");
               }
               productList.add(product);
           }
       } catch (Exception e) {
           System.out.println("DEBUG: Python APIに接続できませんでした。URL = " + url);
       }
       return productList;
   }
   // Object型の数値をintに変換
   private int toInt(Object value) {
       if (value == null) {
           return 0;
       }
       if (value instanceof Number) {
           return ((Number) value).intValue();
       }
       return Integer.parseInt(value.toString());
   }
}


