package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dao.IndexCampaignBannerDAO;
import com.example.demo.model.IndexCampaignBanner;

@Controller
@RequestMapping("/admintop/campaign")
public class AdminCampaignController {

    @Autowired
    private IndexCampaignBannerDAO dao;

    @GetMapping
    public String list(@RequestParam(value="editId", defaultValue="0") int editId, Model model) {
        model.addAttribute("campaignList", dao.findAll());
        model.addAttribute("now", LocalDateTime.now());
        if (editId > 0) model.addAttribute("editCampaign", dao.findById(editId));
        model.addAttribute("mode", "campaign");
        return "admin_top";
    }
    
    private String saveFile(MultipartFile file) {
        try {
            if (file == null || file.isEmpty()) return null;
            String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            String uploadDir = "C:/uploads/images/banners/"; // バナー用フォルダ
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            file.transferTo(new File(dir, fileName));
            return "/images/banners/" + fileName; // 表示用のパス
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    @PostMapping("/save")
    public String save(
            @RequestParam(value="id", defaultValue="0") int id,
            @RequestParam("title") String title,
            @RequestParam(value="imageUrl", required=false) String currentImageUrl,
            @RequestParam("linkUrl") String linkUrl,
            @RequestParam("startAt") String sAt, @RequestParam("endAt") String eAt,
            @RequestParam(value="sortOrder", defaultValue="0") int sortOrder,
            @RequestParam(value="imageFile", required=false) MultipartFile file) {

        // 💡 ここで画像保存処理を呼び出し、URLを取得します
        String imageUrl = (file != null && !file.isEmpty()) ? saveFile(file) : currentImageUrl;

        IndexCampaignBanner c = new IndexCampaignBanner();
        c.setId(id); 
        c.setTitle(title); 
        c.setLinkUrl(linkUrl); 
        c.setSortOrder(sortOrder);
        
        // 日付の処理
        if(sAt != null && !sAt.isEmpty()) c.setStartAt(LocalDateTime.parse(sAt));
        if(eAt != null && !eAt.isEmpty()) c.setEndAt(LocalDateTime.parse(eAt));
        
        // 💡 取得したURLをセットします
        c.setImageUrl(imageUrl);

        if (id == 0) dao.insert(c); else dao.update(c);
        return "redirect:/admintop/campaign";
    }
    @PostMapping("/delete")
    public String delete(@RequestParam("id") int id) { dao.delete(id); return "redirect:/admintop/campaign"; }

    @PostMapping("/swap")
    public String swap(@RequestParam("id1") int id1, @RequestParam("direction") String direction) {
        var list = dao.findAll();
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getId() == id1) {
                int target = "up".equals(direction) ? i - 1 : i + 1;
                if (target >= 0 && target < list.size()) dao.swapSortOrder(id1, list.get(target).getId());
                break;
            }
        }
        return "redirect:/admintop/campaign";
    }
}