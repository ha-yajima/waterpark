package com.example.demo;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan; // ★追加
@SpringBootApplication
@ComponentScan(basePackages = {"com.example.demo"})
public class WaterparkApplication {
	public static void main(String[] args) {
		SpringApplication.run(WaterparkApplication.class, args);
	}
}


