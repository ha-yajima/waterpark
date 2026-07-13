package com.example.demo.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.OrderDAO;

@Controller
public class AdminOrderController {

    @Autowired
    private OrderDAO orderDAO;
    private static final int PAGE_SIZE = 25;

    // 一覧表示
    @GetMapping("/admintop/orders")
    public String listOrders(@RequestParam(required = false) String status, 
                             @RequestParam(defaultValue = "1") int page, Model model) {
        int offset = (page - 1) * PAGE_SIZE;
        model.addAttribute("orders", orderDAO.findPage(status, PAGE_SIZE, offset));
        model.addAttribute("totalPages", (int) Math.ceil((double) orderDAO.countAll(status) / PAGE_SIZE));
        model.addAttribute("currentStatus", status);
        model.addAttribute("currentPage", page);
        model.addAttribute("mode", "orders");
        return "admin_top";
    }

    // 画面遷移なしで詳細を取得するためのAPI
 // AdminOrderController.java の APIメソッド
    @GetMapping("/admintop/orders/api/detail/{orderId}")
    @ResponseBody
    public Map<String, Object> getOrderDetailApi(@PathVariable int orderId) {
        try {
        	Map<String, Object> response = new HashMap<>();
        	response.put("order", orderDAO.getOrderDetail(orderId));
        	response.put("items", orderDAO.getOrderItems(orderId));
        	return response;
        } catch (Exception e) {
            e.printStackTrace(); // ここでコンソールに具体的なエラー内容が出ます
            throw e; // 500エラーの原因を確認するためにあえて投げる
        }
    }
    @PostMapping("/admintop/orders/updateStatus")
    public String updateStatus(@RequestParam int orderId, @RequestParam String status) {
        // DAOを使ってデータベースを更新
        orderDAO.updateStatus(orderId, status);
        
        // 更新後に一覧画面へリダイレクト（絞り込み状態を維持したい場合は調整が必要です）
        return "redirect:/admintop/orders";
    }
}


