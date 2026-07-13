package com.example.demo.model;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Users {
	private int id;
    private String lastName;
    private String firstName;
    private String lastNameKana;
    private String firstNameKana;
    private String email;
    private String password;
    private String phoneNumber;
    private String postalCode;
    private String prefecture;
    private String address1;
    private String address2;
    private LocalDateTime createdAt;
    private boolean isWithdrawn;
    private java.sql.Timestamp withdrawnAt;
   
    
    

}
