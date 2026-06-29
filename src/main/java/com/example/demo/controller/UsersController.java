package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.dao.UsersDAO;
import com.example.demo.model.Users;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/users")
public class UsersController {

    @Autowired
    private UsersDAO usersDAO;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // 1. 会員登録（入力画面の表示）
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new Users());
        return "users/register_input";
    }

    // 2. 会員登録（確認画面の表示）
    @PostMapping("/register/confirm")
    public String confirmRegister(@ModelAttribute("user") Users user, Model model) {
        model.addAttribute("user", user);
        return "users/register_confirm"; 
    }

    // 3. 会員登録（実行処理）
    @PostMapping("/register/execute")
    public String executeRegister(@ModelAttribute("user") Users user, HttpSession session) { 
        String rawPassword = user.getPassword();
        String hashedPassword = passwordEncoder.encode(rawPassword);
        user.setPassword(hashedPassword); 

        usersDAO.insert(user);
        Users loginUser = usersDAO.findByEmail(user.getEmail());
        session.setAttribute("loginUser", loginUser);

        return "redirect:/"; 
    }
    
    //1.会員情報変更
    @GetMapping("/edit")
    public String showEditForm(HttpSession session, Model model) {
        Users loginUser = (Users) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "redirect:/auth/login";
        }

        model.addAttribute("user", loginUser);
        return "users/edit_profile"; 
    }

    // 2. 会員情報変更（実行処理）
    @PostMapping("/edit")
    public String executeEdit(@ModelAttribute("user") Users user,
    		HttpSession session,
    		RedirectAttributes redirectAttributes){
        Users loginUser = (Users) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }
        
        user.setId(loginUser.getId());
        usersDAO.update(user);
        session.setAttribute("loginUser", user);

        redirectAttributes.addFlashAttribute("successMessage", "会員情報を更新しました。");
        return "redirect:/users/edit";
    }
    
 // 1. 退会画面の表示
    @GetMapping("/withdraw")
    public String showWithdrawForm(HttpSession session, Model model) {
        Users loginUser = (Users) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }
        model.addAttribute("user", loginUser);
        return "users/withdraw_confirm";
    }

    // 2. 退会処理（実行）
    @PostMapping("/withdraw")
    public String executeWithdraw(HttpSession session) { 
        Users loginUser = (Users) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }

        int id = loginUser.getId();
        usersDAO.delete(id);

        session.invalidate();

        return "redirect:/";
    }
    
}