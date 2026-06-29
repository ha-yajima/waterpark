package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.dao.InquiriesDAO;
import com.example.demo.model.Inquiry;

@Controller
@RequestMapping("/inquiries")
public class InquiriesController {

    @Autowired
    private InquiriesDAO inquiriesDAO;

    // 1. 問い合わせ（入力画面の表示）
    @GetMapping
    public String showInquiryForm(Model model) {
        // 画面のフォームとデータをバインドするための空の器を渡す
        model.addAttribute("inquiry", new Inquiry());
        return "inquiries/input"; // WEB-INF/jsp/inquiries/input.jsp を表示
    }

    // 2. 問い合わせ（確認画面の表示）
    @PostMapping("/confirm")
    public String confirmInquiry(@ModelAttribute("inquiry") Inquiry inquiry, Model model) {
        // 入力されたデータをそのまま確認画面に引き渡す
        model.addAttribute("inquiry", inquiry);
        return "inquiries/confirm"; // WEB-INF/jsp/inquiries/confirm.jsp を表示
    }

    // 3. 問い合わせ（実行処理）
    @PostMapping("/execute")
    public String executeInquiry(@ModelAttribute("inquiry") Inquiry inquiry) {
        // InquiriesDAOを使ってDBにINSERT
        inquiriesDAO.insert(inquiry);

        // 登録が成功したら、完了画面がないため一旦入力画面（またはTOPなど）へリダイレクト
        // ※チームで「完了画面」を作る場合はここの戻り先を調整します
        return "redirect:/inquiries";
    }
}