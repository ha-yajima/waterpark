package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dao.IndexNewsDAO;
import com.example.demo.model.IndexNews;

@Controller
public class AdminNewsController {

    @Autowired
    private IndexNewsDAO indexNewsDAO;

    @GetMapping("/admintop/news")
    public String listNews(
            @RequestParam(value = "editId", required = false, defaultValue = "0") int editId,
            Model model) {
        
        List<IndexNews> newsList = indexNewsDAO.findAll();
        model.addAttribute("newsList", newsList);
        model.addAttribute("mode", "news"); // 🔥 これが必須！

        if (editId > 0) {
            model.addAttribute("editNews", indexNewsDAO.findById(editId));
        }
        
        return "admin_top";
    }

    @PostMapping("/admintop/news/save")
    public String saveNews(
            @RequestParam(value = "id", required = false, defaultValue = "0") int id,
            @RequestParam("title") String title,
            @RequestParam("content") String content) {
        
        IndexNews news = new IndexNews(id, title, content, null);
        
        if (id == 0) {
            indexNewsDAO.insert(news);
        } else {
            indexNewsDAO.update(news);
        }
        return "redirect:/admintop/news";
    }

    @PostMapping("/admintop/news/delete")
    public String deleteNews(@RequestParam("id") int id) {
        indexNewsDAO.delete(id);
        return "redirect:/admintop/news";
    }
}