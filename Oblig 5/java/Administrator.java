import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;

import java.lang.*; //isEmpty()

public class Administrator {

    public static void main(String[] agrs) {

        String dbname = "krisgrav"; // Input your UiO-username
        String user = "krisgrav_priv"; // Input your UiO-username + _priv
        String pwd = "AThohp9uze"; // Input the password for the _priv-user you got in a mail
        // Connection details
        String connectionStr =
            "user=" + user + "&" +
            "port=5432&" +
            "password=" + pwd + "";

        String host = "jdbc:postgresql://dbpg-ifi-kurs01.uio.no";
        String connectionURL =
            host + "/" + dbname +
            "?sslmode=require&ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory&" +
            connectionStr;

        try {
            // Load driver for PostgreSQL
            Class.forName("org.postgresql.Driver");
            // Create a connection to the database
            Connection connection = DriverManager.getConnection(connectionURL);

            int ch = 0;
            while (ch != 3) {
                System.out.println("-- ADMINISTRATOR --");
                System.out.println("Please choose an option:\n 1. Create bills\n 2. Insert new product\n 3. Exit");
                ch = getIntFromUser("Option: ", true);

                if (ch == 1) {
                    makeBills(connection);
                } else if (ch == 2) {
                    insertProduct(connection);
                }
            }
        } catch (SQLException|ClassNotFoundException ex) {
            System.err.println("Error encountered: " + ex.getMessage());
        }
    }

    private static void makeBills(Connection connection)  throws SQLException {
      String name = "";
      String address = "";
      float totDue = 0;
      String username = getStrFromUser("Insert username: ");

      String statement1 = //Statement med brukernavn
        "SELECT u.name, u.address, SUM(p.price * o.num) AS total " +
        "FROM ws.users u " +
          "INNER JOIN ws.orders o ON (o.uid = u.uid) " +
          "INNER JOIN ws.products p ON (o.pid = p.pid) " +
        "WHERE o.payed = 0 AND u.username = ? " +
        "GROUP BY (u.name, u.address);"
      ;
      String statement2 = //Statement uten brukernavn
      "SELECT u.name, u.address, SUM(p.price * o.num) AS total " +
      "FROM ws.users u " +
        "INNER JOIN ws.orders o ON (o.uid = u.uid) " +
        "INNER JOIN ws.products p ON (o.pid = p.pid) " +
      "WHERE o.payed = 0 " +
      "GROUP BY (u.name, u.address);"
      ;

      PreparedStatement statement = connection.prepareStatement(statement1);
      if(username.isEmpty()){
        statement = connection.prepareStatement(statement2);
      }else{
        statement.setString(1, username);
      }

      ResultSet results = statement.executeQuery();
      try{
        while(results.next()){
          name = results.getString("name");
          address = results.getString("address");
          totDue = results.getFloat("total");
          System.out.print("\n--Bill--\n");
          System.out.print("Name: " + name + "\n");
          System.out.print("Address: " + address + "\n");
          System.out.print("Total due: " + totDue + ",-");
          System.out.println("");
        }
      }
      catch(SQLException e){
        System.out.println("SQLException caught!");
      }
    }


    private static void insertProduct(Connection connection) throws SQLException {
      System.out.println("--Insert new product--");

      String productName = getStrFromUser("Product name: ");

      String priceString = getStrFromUser("Price (use decimal): ");
      float price = Float.parseFloat(priceString);

      String description = getStrFromUser("Product description: ");

      System.out.println("--Select product category--");
      System.out.println("Food");
      System.out.println("Electronics");
      System.out.println("Clothing");
      System.out.println("Games");
      String category = getStrFromUser("");
      int cid = 0;
      if(category.toLowerCase() == "food"){
        cid = 1;
      }else if(category.toLowerCase() == "electronics"){
        cid = 2;
      }else if(category.toLowerCase() == "clothing"){
        cid = 3;
      }else if(category.toLowerCase() == "games"){
        cid = 4;
      }

      String statementString =
      "INSERT INTO ws.products (name, price, cid, description) " +
      "VALUES (?, ?, (SELECT c.cid FROM ws.categories c WHERE c.cid = ?), ?);";

      PreparedStatement statement = connection.prepareStatement(statementString);
      statement.setString(1, productName);
      statement.setFloat(2, price);
      statement.setInt(3, cid);
      statement.setString(4, description);
      statement.executeUpdate();

      System.out.println("\n" + productName + " added to products\n");
    }

    /**
     * Utility method that gets an int as input from user
     * Prints the argument message before getting input
     * If second argument is true, the user does not need to give input and can leave
     * the field blank (resulting in a null)
     */
    private static Integer getIntFromUser(String message, boolean canBeBlank) {
        while (true) {
            String str = getStrFromUser(message);
            if (str.equals("") && canBeBlank) {
                return null;
            }
            try {
                return Integer.valueOf(str);
            } catch (NumberFormatException ex) {
                System.out.println("Please provide an integer or leave blank.");
            }
        }
    }

    /**
     * Utility method that gets a String as input from user
     * Prints the argument message before getting input
     */
    private static String getStrFromUser(String message) {
        Scanner s = new Scanner(System.in);
        System.out.print(message);
        return s.nextLine();
    }
}
