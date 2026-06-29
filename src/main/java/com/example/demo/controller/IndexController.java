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

        List<IndexCampaignBanner> bannerList = bannerDAO.findAll();
        List<IndexNews> newsList = newsDAO.findLatestNews();

        
     // 💡 Python API からランキングデータを取得する処理を追加
        String pythonUrl = "http://127.0.0.1:8000/recommendations/";
        RestTemplate restTemplate = new RestTemplate();
        List<Map<String, Object>> rankingProductList = new ArrayList<>();

        try {
            // PythonからJSONデータを取得してMapに変換
            Map<String, Object> response = restTemplate.getForObject(pythonUrl, Map.class);
            if (response != null && response.containsKey("recommendations")) {
                rankingProductList = (List<Map<String, Object>>) response.get("recommendations");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Pythonサーバーが起動していない場合は、空のリストのままにしてエラー落ちを防ぐ
        }
        
     // 2. 💡 おすすめ商品データの取得（新規追加）
        String featuredUrl = "http://127.0.0.1:8000/recommendations/featured/";
        List<Map<String, Object>> recommendedProductList = new ArrayList<>();
        try {
            Map<String, Object> response = restTemplate.getForObject(featuredUrl, Map.class);
            if (response != null && response.containsKey("recommendations")) {
                recommendedProductList = (List<Map<String, Object>>) response.get("recommendations");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
     // 3. 💡 新着商品データの取得（新規追加）
        String newUrl = "http://127.0.0.1:8000/recommendations/new/";
        List<Map<String, Object>> newProductList = new ArrayList<>();
        try {
            Map<String, Object> response = restTemplate.getForObject(newUrl, Map.class);
            if (response != null && response.containsKey("new_arrivals")) { // 💡キー名は "new_arrivals"
                newProductList = (List<Map<String, Object>>) response.get("new_arrivals");
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
}

