package com.attendance.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConfig provides a central JDBC connection to MySQL.
 * Every service class calls getConnection() inside a try-with-resources
 * block so connections are always closed automatically.
 *
 * XAMPP default: host=localhost, port=3306, user=root, password=(empty)
 */
public class DBConfig {

    private static final String DB_URL =
        "jdbc:mysql://localhost:3306/attendance_db" +
        "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    private static final String DB_USER = "root";
    private static final String DB_PASS = "";
    private static final String DRIVER  = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL driver not found: " + e.getMessage());
        }
    }
}