<%-- 
    Document   : shopping
    Created on : Dec 10, 2025, 10:00:51 PM
    Author     : msi2k
--%>

<%@page import="java.util.List"%>
<%@page import="fa3w.products.ProductDTO"%>
<%@page import="fa3w.users.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>Shopping Page</title>
        <link rel="stylesheet" href="css/shoppingStyle.css"/>
    </head>
    <body>
        <%
            UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
            if (loginUser == null || !"US".equals(loginUser.getRoleID())) {
                response.sendRedirect("login.jsp");
                return;
            }
            String search = request.getParameter("txtName");
            if (search == null) {
                search = "";
            }
        %>

        <div class="container">
            <div class="shopping-header">
                <div class="brand-section">
                    <h1>Tech<span>Store</span></h1>
                    <div class="user-welcome">
                        Welcome, <strong><%= loginUser.getFullName()%></strong>


                    </div>
                </div>

                <div class="action-section">
                    <form action="MainController" class="search-form">
                        <input type="text" name="txtName" value="<%= search%>" placeholder="Find laptops, mouse..." required="" class="search-input" />
                        <button type="submit" value="Search Product" name="action" class="btn-search">Search</button>
                    </form>

                    <form action="MainController">
                        <input type="submit" value="View Cart" name="action" class="btn-view-cart" />
                    </form>
                    <form action="MainController">
                        <input type="submit" value="Back" name="action" class="btn-back-user" />
                    </form>
                </div>
            </div>
            <%
                String error = (String) request.getAttribute("ERROR");
                if (error != null && !error.isEmpty()) {
            %>
            <div class="message-box msg-error">
                <%= error%>
            </div>
            <% } %>

            <%
                String message = (String) request.getAttribute("MESSAGE");
                if (message != null && !message.isEmpty()) {
            %>
            <div class="message-box msg-success">
                <%= message%>
            </div>
            <% }%>

            <%
                List<ProductDTO> listProduct = (List<ProductDTO>) request.getAttribute("LIST_PRODUCT");
                if (listProduct != null && listProduct.size() > 0) {
            %>
            <div class="table-container">
                <table class="product-table">
                    <thead>
                        <tr>
                            <th style="width: 5%; text-align: center;">No.</th>
                            <th style="width: 15%;">Product ID</th>
                            <th style="width: 35%;">Name</th>
                            <th style="width: 15%;">Price</th>
                            <th style="width: 10%;">Stock</th>
                            <th style="width: 20%;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int count = 1;
                            for (ProductDTO product : listProduct) {
                        %>
                        <tr>
                    <form action="MainController" method="POST" class="add-form">
                        <td style="text-align: center;"><%= count++%></td>
                        <td><span class="col-id"><%= product.getProductID()%></span></td>
                        <td class="col-name"><%= product.getName()%></td>
                        <td class="col-price">$<%= product.getPrice()%></td>
                        <td class="col-stock"><%= product.getQuantity()%> available</td>
                        <td>
                            <div style="display: flex; gap: 10px; align-items: center;">
                                <input type="number" name="quantity" value="1" min="1" max="<%= product.getQuantity()%>" required="" class="qty-input"/>
                                <input type="hidden" name="id" value="<%= product.getProductID()%>"/>
                                <input type="hidden" name="txtName" value="<%= search%>"/>
                                <input type="submit" value="Add" name="action" class="btn-add" />
                            </div>
                        </td>
                    </form>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
            <%
                }
            %>

            <div style="height: 50px;"></div>
        </div>
    </body>
</html>
