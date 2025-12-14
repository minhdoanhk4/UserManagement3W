<%-- 
    Document   : user
    Created on : Dec 2, 2025, 3:32:33 PM
    Author     : msi2k
--%>

<%@page import="fa3w.users.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>User Page</title>
        <link rel="stylesheet" href="css/userStyle.css"/>

    </head>
    <body>

        <%
            UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
            if (loginUser == null || !"US".equals(loginUser.getRoleID())) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        <div class="container">
            <div class="header-user">
                <div class="welcome-text">
                    Welcome, <span><%= loginUser.getFullName()%></span>
                </div>

                <form action="MainController">
                    <input type="submit" value="Logout" name="action" class="logout-btn" />
                </form>
            </div>

            <h1 class="page-title">My Profile Information</h1>

            <div class="user-card"> 
                <p>
                    <label>User ID:</label> <span><%= loginUser.getUserID()%></span>
                </p>
                <p>
                    <label>Full Name:</label> <span><%= loginUser.getFullName()%></span>
                </p>
                <p>
                    <label>Role ID:</label> <span><%= loginUser.getRoleID()%></span>
                </p>
                <p>
                    <label>Password:</label> <span><%= loginUser.getPassword()%></span>
                </p>
            </div> 
            <div class ="btn-shopping">
                <form action="MainController" method="POST">
                    <input type="submit" value="Shopping Page" name="action" class="shopping" />
                </form>
            </div>
            <div class="footer">
                Copyright &copy; 2025 User Management 3W. All rights reserved.
            </div>
        </div>

    </body>
</html>
