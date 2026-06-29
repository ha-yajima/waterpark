package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dao.CampaignDAO;
import com.example.demo.model.Campaign;

@Controller
@RequestMapping("/admintop/campaign")
public class AdminCampaignController {
    @Autowired
    private CampaignDAO dao;

    @GetMapping
    public String list(@RequestParam(value="editId", defaultValue="0") int editId, Model model) {
        model.addAttribute("campaignList", dao.findAll());
        if (editId > 0) model.addAttribute("editCampaign", dao.findById(editId));
        model.addAttribute("mode", "campaign");
        return "admin_top";
    }

    @PostMapping("/save")
    public String save(Campaign c, @RequestParam("imageFile") MultipartFile file) {
        if (!file.isEmpty()) {
            // ここにファイル保存処理を記述
            c.setImageUrl("/images/banners/" + file.getOriginalFilename());
        }
        dao.update(c);
        return "redirect:/admintop/campaign";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("id") int id) {
        dao.delete(id);
        return "redirect:/admintop/campaign";
    }
}