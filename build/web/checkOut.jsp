<%-- 
    Document   : checkOut
    Created on : Dec 12, 2025, 10:48:11 PM
    Author     : msi2k
--%>

<%@page import="fa3w.products.ProductDTO"%>
<%@page import="fa3w.products.Cart"%>
<%@page import="fa3w.users.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>Checkout Page</title>
        <link rel="stylesheet" href="css/checkoutStyle.css"/>
    </head>
    <body>
        <h1>Check Out Your Cart</h1>
        <%
            UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
            if (loginUser == null || !"US".equals(loginUser.getRoleID())) {
                response.sendRedirect("login.jsp");
                return;
            }
            String error = (String) request.getAttribute("ERROR");
            if (error != null) {
        %>

        <font color="red">
        <%= error%>
        </font>

        <%
            }
        %>

        <%
            Cart cart = (Cart) session.getAttribute("CART");
            if (cart != null && cart.getCart().size() > 0) {
        %>

        <table border="1">
            <thead>
                <tr>
                    <th>No.</th>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int count = 1;
                    double total = 0;
                    for (ProductDTO product : cart.getCart().values()) {
                        total += product.getQuantity() * product.getPrice();

                %>
                <tr>
                    <td><%= count++%></td>
                    <td><%= product.getProductID()%></td>
                    <td><%= product.getName()%></td>
                    <td><%= product.getPrice()%></td>
                    <td><%= product.getQuantity()%></td>
                    <td><%= product.getPrice() * product.getQuantity()%></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
                <h2>
                    Total Amount:<%= total%>$
                </h2>

        <form action="MainController" method="POST">
            <input type="submit" value="Confirm" name="action"/>
        </form>

        <form action="MainController">
            <input type="submit" value="View Cart" name="action" />
        </form>
        <%
        } else {
        %>
        <h2>Your cart is empty. <a href="shopping.jsp">Go shopping</a></h2>
        <%
            }

        %>
    </body>
</html>
