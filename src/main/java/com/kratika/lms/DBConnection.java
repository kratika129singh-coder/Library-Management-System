package com.kratika.lms;
import java.sql.Connection;
import java.sql.DriverManager;
public class DBConnection
{
    public static Connection getConnection()
    {
        Connection con = null;
        try
        {
            Class.forName("com.mysql.cj.jdbc.Driver");//registration for the JDBC driver
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms_intellj", "root", "root");
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return con;
    }
    public static void main(String[] args)
    {
        if(getConnection()!=null)
        {
            System.out.println("Connection Success!");
        }
        else
        {
            System.out.println("Connection Failed");
        }
    }
}
