package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dao.InquiriesDAO;
import com.example.demo.dao.ProductDAO;
import com.example.demo.model.Inquiry;
import com.example.demo.model.ProductFormItem;

@Controller
public class AdminMainController {
    
    @Autowired
    private ProductDAO productDAO;

    @Autowired
    private InquiriesDAO inquiriesDAO;

    @GetMapping("/admintop/main")
    public String adminMain(
            @RequestParam(value = "mode", required = false, defaultValue = "top") String mode,
            @RequestParam(value = "page", required = false, defaultValue = "1") int currentPage,
            Model model) {
        
        // 1. 商品管理モード
        if ("product".equals(mode)) {
            List<ProductFormItem> list = productDAO.findJoinedAll();
            model.addAttribute("productList", list);
        } 
        // 2. お問い合わせ管理モード
        else if ("inquiry".equals(mode)) {
            int limit = 20;
            if (currentPage < 1) currentPage = 1;
            int offset = (currentPage - 1) * limit;
            
            int totalCount = inquiriesDAO.countAll();
            List<Inquiry> inquiryList = inquiriesDAO.findPage(limit, offset);
            
            int totalPages = (int) Math.ceil((double) totalCount / limit);
            if (totalPages < 1) totalPages = 1;
            
            model.addAttribute("inquiryList", inquiryList);
            model.addAttribute("currentPage", currentPage);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("totalCount", totalCount);
        }
        
        model.addAttribute("mode", mode);
        return "admin_top";
    }
}