package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dao.UsersDAO;
import com.example.demo.model.Users;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UsersDAO usersDAO;

    @Autowired
    private PasswordEncoder passwordEncoder; 

    @GetMapping("/login")
    public String showLoginForm() {
        return "auth/login"; 
    }

    @PostMapping("/login")
    public String login(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {

        Users user = usersDAO.findByEmail(email);

        if (user != null && passwordEncoder.matches(password, user.getPassword())) {
            session.setAttribute("loginUser", user);
            return "redirect:/"; 
        } else {
            model.addAttribute("error", "メールアドレスまたはパスワードが違います。");
            return "auth/login";
        }
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}