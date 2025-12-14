<%-- 
    Document   : viewCart
    Created on : Dec 11, 2025, 11:22:25 PM
    Author     : msi2k
--%>

<%@page import="fa3w.products.Cart"%>
<%@page import="fa3w.users.UserDTO"%>
<%@page import="fa3w.products.ProductDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>Cart Page</title>
        <link rel="stylesheet" href="css/cartStyle.css"/>
    </head>
    <body>
        <%
            // Kiểm tra đăng nhập
            UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
            if (loginUser == null || !"US".equals(loginUser.getRoleID())) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <div class="container">
            <div class="cart-header-bar">
                <h1 class="page-title">Your Shopping Cart</h1>
                <a href="MainController?action=Search+Product" class="shopping-btn">
                    <span>&#8592;</span> Continue Shopping
                </a>
            </div>

            <%
                String error = (String) request.getAttribute("ERROR");
                if (error != null) {
            %>
            <div style="background-color: #fee2e2; color: #ef4444; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #fecaca;">
                <%= error%>
            </div>
            <%
                }
            %>

            <%
                Cart cart = (Cart) session.getAttribute("CART");
                if (cart != null && cart.getCart().size() > 0) {
            %>
            
            <table class="cart-table">
                <thead>
                    <tr>
                        <th style="width: 5%">No.</th>
                        <th style="width: 15%">ID</th>
                        <th style="width: 30%; text-align: left; padding-left: 20px;">Product Name</th>
                        <th style="width: 15%">Price</th>
                        <th style="width: 10%">Qty</th>
                        <th style="width: 15%">Total</th>
                        <th style="width: 10%" colspan="2">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int count = 1;
                        double total = 0;
                        for (ProductDTO product : cart.getCart().values()) {
                            total += product.getQuantity() * product.getPrice();
                    %>
                    <form action="MainController" method="POST">
                        <tr>
                            <td><%= count++%></td>
                            <td style="font-family: monospace; color: #64748b;"><%= product.getProductID()%></td>
                            <td style="text-align: left; padding-left: 20px; font-weight: 600;"><%= product.getName()%></td>
                            <td>$<%= String.format("%.2f", product.getPrice())%></td>
                            <td>
                                <input type="number" name="quantity" value="<%= product.getQuantity()%>" required="" min="1" class="quantity-input"/>
                            </td>
                            <td style="color: var(--primary); font-weight: 700;">
                                $<%= String.format("%.2f", product.getPrice() * product.getQuantity())%>
                            </td>
                            
                            <td style="padding: 5px;">
                                <input type="hidden" name="id" value="<%= product.getProductID()%>"/>
                                <input type="submit" value="Edit" name="action" class="edit-btn"/>
                            </td>
                            <td style="padding: 5px;">
                                <input type="submit" value="Remove" name="action" class="remove-btn"/>
                            </td>
                        </tr>
                    </form>
                    <%
                        }
                    %>
                </tbody>
            </table>

            <div class="cart-footer-bar">
                <div class="cart-summary">
                    <p>Total Amount: <span class="total-amount">$<%= String.format("%.2f", total)%></span></p>
                </div>
                
                <form action="MainController">
                    <input type="submit" value="Check Out" name="action" class="checkout-btn" />
                </form>
            </div>

            <%
            } else {
            %>
                <div class="empty-cart-message">
                    <img src="https://cdn-icons-png.flaticon.com/512/11329/11329060.png" alt="Empty Cart" style="width: 100px; opacity: 0.5; margin-bottom: 20px;">
                    <p>Your cart is currently empty.</p>
                    <a href="MainController?action=Search+Product" style="color: var(--primary); text-decoration: none; font-weight: 600;">Go to Store</a>
                </div>
            <%
                }
            %>
        </div>
</body>
</html>
