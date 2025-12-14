<%-- 
    Document   : admin
    Created on : Dec 2, 2025, 3:32:40 PM
    Author     : msi2k
--%>

<%@page import="java.util.List"%>
<%@page import="fa3w.users.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>ADMIN PAGE</title>

        <link rel="stylesheet" href="css/adminStyle.css"/>
    </head>
    <body>
        <%-- Giữ nguyên logic kiểm tra quyền --%>
        <%
            UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
            if (loginUser == null || !"AD".equals(loginUser.getRoleID())) {
                response.sendRedirect("login.jsp");
                return;
            }
            String search = request.getParameter("txtSearchValue");
            if (search == null) {
                search = "";
            }
            String error = (String) request.getAttribute("ERROR");
            if (error == null)
                error = "";
        %>
        <div class="container">
            <div class="header-container">
                <div class="welcome-section">
                    <h1>Dashboard</h1>
                    <span style="font-size: 14px; opacity: 0.9">Hello, <font><%= loginUser.getFullName()%></font></span>
                </div>

                <div class="center-actions">
                    <form action="MainController" class="header-search-form">
                        <input type="text" name="txtSearchValue" value="<%= search%>" placeholder="Search user..." required="" />
                        <input type="submit" value="Search" name="action" />
                    </form>
                    <form action="MainController">
                        <input type="submit" value="Logout" name="action" class="logout-btn"/>
                    </form>
                </div>
            </div>

            <% if (error.length() > 0) {%>
            <div style="background: #fee2e2; color: #b91c1c; padding: 10px; border-radius: 8px; margin-bottom: 20px;">
                <%= error%>
            </div>
            <% } %>

            <div class="table">
                <%-- Giữ nguyên logic hiển thị bảng --%>
                <%
                    List<UserDTO> listUser = (List<UserDTO>) request.getAttribute("LIST_USER");
                    if (listUser != null && listUser.size() > 0) {
                %>
                <table>
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>User ID</th>
                            <th>Full Name</th>
                            <th>Role</th>
                            <th>Password</th>
                            <th>Update</th>
                            <th>Delete</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int count = 1;
                            for (UserDTO user : listUser) {
                        %>
                    <form action="MainController" method="POST">
                        <tr>
                            <td><%= count++%></td>
                            <td>
                                <input type="text" name="userID" value="<%= user.getUserID()%>" readonly="" style="border:none; border-bottom: none; color: #64748b; font-weight: 600;"/>
                            </td>
                            <td><input type="text" name="fullName" value="<%= user.getFullName()%>" required=""/></td>
                            <td><input type="text" name="roleID" value="<%= user.getRoleID()%>" required="" style="width: 50px; text-align: center;"/></td>
                            <td><%= user.getPassword()%></td> <td>
                                <input type="submit" value="Update" name="action" />
                                <input type="hidden" name="txtSearchValue" value="<%= search%>" />
                            </td>
                            <td>
                                <a href="MainController?action=Delete&userID=<%= user.getUserID()%>&txtSearchValue=<%= search%>" onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                            </td>
                        </tr>
                    </form>
                    <% } %>
                    </tbody>
                </table>

                <%-- Pagination giữ nguyên logic, class css đã được update --%>
                <div class="pagination">
                    <%
                        Integer endPage = (Integer) request.getAttribute("endPage");
                        Integer currentPage = (Integer) request.getAttribute("currentPage");
                        String currentSearch = (String) request.getAttribute("txtSearchValue");
                        if (endPage == null) {
                            endPage = 0;
                        }
                        if (currentPage == null) {
                            currentPage = 1;
                        }
                        if (currentSearch == null) {
                            currentSearch = "";
                        }

                        if (endPage > 1) {
                            if (currentPage > 1) {
                    %>
                    <a href="MainController?action=Search&index=<%=currentPage - 1%>&txtSearchValue=<%=currentSearch%>">&laquo;</a>
                    <%      }
                        for (int i = 1; i <= endPage; i++) {
                            String activeClass = (currentPage == i) ? "active" : "";
                    %>
                    <a href="MainController?action=Search&index=<%=i%>&txtSearchValue=<%=currentSearch%>" class="<%=activeClass%>"><%=i%></a>
                    <%      }
                        if (currentPage < endPage) {
                    %>
                    <a href="MainController?action=Search&index=<%=currentPage + 1%>&txtSearchValue=<%=currentSearch%>">&raquo;</a>
                    <%      }
                        }
                    %>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </body>
</html>
