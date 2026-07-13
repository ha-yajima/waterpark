package com.example.demo;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 「/images/**」も「/uploads/**」も、両方とも同じ実フォルダ（uploads/images）を見る
        registry.addResourceHandler("/images/**")
            .addResourceLocations("file:///C:/uploads/images/");

        registry.addResourceHandler("/uploads/**")
            .addResourceLocations("file:///C:/uploads/images/");
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
    }
}