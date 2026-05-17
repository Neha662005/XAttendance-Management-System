package com.attendance.controllers;

import org.mindrot.jbcrypt.BCrypt;

public class HashGen {
    public static void main(String[] args) {

        // Change this password to whatever you want
        String password = "Admin@123";

        String hash = BCrypt.hashpw(password, BCrypt.gensalt(12));

        System.out.println("Password: " + password);
        System.out.println("Hash:     " + hash);
        System.out.println();
        System.out.println("-- Copy the hash above and paste into the SQL below:");
        System.out.println();
        System.out.println("USE attendance_db;");
        System.out.println("UPDATE users");
        System.out.println("SET password_hash = '" + hash + "'");
        System.out.println("WHERE email IN (");
        System.out.println("    'superadmin@demo.com',");
        System.out.println("    'admin@demo.com',");
        System.out.println("    'employee@demo.com'");
        System.out.println(");");
    }
}