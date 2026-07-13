package com.example.demo.controller;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
        return "inquiries/input";
    }

    // 2. 問い合わせ（確認画面の表示）
    @PostMapping("/confirm")
    public String confirmInquiry(@ModelAttribute("inquiry") Inquiry inquiry, 
                                 @RequestParam("imageFile") MultipartFile imageFile, 
                                 Model model) {
        
        if (!imageFile.isEmpty()) {
            try {
                // ファイル名を生成（ここでは簡易的に元の名前を使用）
                String fileName = imageFile.getOriginalFilename();
                File dest = new File("C:/uploads/images/contacts/" + fileName);
                imageFile.transferTo(dest);
                
                // DBに保存するパスをセット（URLとしてアクセス可能な形式）
                inquiry.setImageUrl("/uploads/contacts/" + fileName);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        model.addAttribute("inquiry", inquiry);
        return "inquiries/confirm";
    }

    // 3. 問い合わせ（実行処理）
    @PostMapping("/execute")
    public String executeInquiry(@ModelAttribute("inquiry") Inquiry inquiry, 
                                 RedirectAttributes redirectAttributes) {
        inquiriesDAO.insert(inquiry);

        // リダイレクト先で使えるメッセージをセット
        redirectAttributes.addFlashAttribute("message", "お問い合わせを送信しました。");
        
        return "redirect:/inquiries";
    }
}
