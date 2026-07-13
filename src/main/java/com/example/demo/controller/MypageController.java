package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.dao.MypageDAO;
import com.example.demo.model.Users;

import jakarta.servlet.http.HttpSession;

@Controller
public class MypageController {

    @Autowired
    private MypageDAO mypageDAO;

    @Autowired
    private HttpSession session;

    @GetMapping("/mypage")
    public String showMypage(Model model, HttpSession session) { // 引数から受け取るのが安全です
        // 1. セッションから "loginUser" という名前で取り出す
        Users user = (Users) session.getAttribute("loginUser");
        
        System.out.println("★セッションから取得したユーザーID: " + (user != null ? user.getId() : "null"));

        // 2. ログインしていない場合はログイン画面へ
        if (user == null) {
        	return "redirect:/auth/login?redirect=/mypage";
        }

        // 3. ユーザーオブジェクトからIDを取り出す（ここがポイント！）
        int userId = user.getId(); 

        // 4. あとはDAOで履歴を取得するだけ
        List<Map<String, Object>> orderHistory = mypageDAO.getOrderHistory(userId);
        model.addAttribute("orderHistory", orderHistory);

        return "mypage";
    }
}