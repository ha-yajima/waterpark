package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminLoginController {

    // 1. ログイン画面を表示する (GET)
    @GetMapping("/admintop/login")
    public String showLoginPage() {
        // WEB-INF/jsp/admin_login.jsp を読み込む
        return "admin_login";
    }

    // 2. ログインボタンが押された時の認証処理 (POST)
    @PostMapping("/admintop/login")
    public String loginProcessing(
            @RequestParam("adminId") String adminId,
            @RequestParam("password") String password,
            HttpSession session) {

        // 仮の簡易認証（※後でUserDAOを使ってDB照合に書き換えます）
        if ("admin".equals(adminId) && "password123".equals(password)) {
            
            // 💡【重要ポイント】矢嶋さんと被らないキー名「loginAdmin」でセッション保存！
            session.setAttribute("loginAdmin", adminId);
            
            // 認証成功したら、林さんの管理メイン画面へリダイレクト
            return "redirect:/admintop/main";
        }

        // 認証失敗したら、エラーの目印を持ってログイン画面に戻す
        return "redirect:/admintop/login?error=true";
    }
}