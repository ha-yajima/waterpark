package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.dao.InquiriesDAO;
import com.example.demo.model.Inquiry;

@Controller
public class AdminInquiryController {

    @Autowired
    private InquiriesDAO inquiriesDAO;

    // 1. お問い合わせ一覧の表示 (管理者トップから mode=inquiry で呼ばれる想定、または直接遷移)
    @GetMapping("/admin/inquiry/list")
    public String listInquiries(Model model) {
        System.out.println("====== 📩 お問い合わせ一覧取得開始 ======");
        
        List<Inquiry> inquiryList = inquiriesDAO.findAll();
        model.addAttribute("inquiryList", inquiryList);
        
        // 管理者トップの共通枠（main.jspなど）へ、お問い合わせモードとして遷移
        return "redirect:/admintop/main?mode=inquiry";
    }

    // 2. お問い合わせの対応ステータス変更処理 (POST)
    @PostMapping("/admin/inquiry/updateStatus")
    public String updateInquiryStatus(
            @RequestParam("inquiryId") int inquiryId,
            @RequestParam("status") String status,
            RedirectAttributes redirectAttributes) {
        
        System.out.println("====== 🔄 お問い合わせステータス変更 ======");
        System.out.println("対象ID: " + inquiryId + " / 新ステータス: " + status);
        
        // DAOを使ってDBのstatus（未対応・対応中・対応済み）を更新
        inquiriesDAO.updateStatus(inquiryId, status);
        
        // 画面に完了メッセージを表示したい場合はフラッシュ属性を入れる
        redirectAttributes.addFlashAttribute("message", "お問合せのステータスを「" + status + "」に更新しました。");
        
        // 更新が終わったら、管理者トップのお問い合わせ画面（mode=inquiry）に戻す
        return "redirect:/admintop/main?mode=inquiry";
    }
}