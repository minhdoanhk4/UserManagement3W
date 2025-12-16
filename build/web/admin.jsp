<%-- 
    Document   : admin
    Created on : Dec 2, 2025, 3:32:40 PM
    Author     : msi2k
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

        <c:if test="${sessionScope.LOGIN_USER == null || sessionScope.LOGIN_USER.roleID ne 'AD'}">
            <c:redirect url="login.jsp"/>
        </c:if>
        <div class="container">
            <div class="header-container">
                <div class="welcome-section">
                    <h1>Dashboard</h1>
                    <span style="font-size: 14px; opacity: 0.9">Hello, <font>${sessionScope.LOGIN_USER.fullName}</font></span>
                </div>

                <div class="center-actions">
                    <form action="MainController" class="header-search-form">
                        <input type="text" name="txtSearchValue" value="${param.txtSearchValue}" placeholder="Search user..." required="" />
                        <input type="submit" value="Search" name="action" />
                    </form>
                    <form action="MainController">
                        <input type="submit" value="Logout" name="action" class="logout-btn"/>
                    </form>
                </div>
            </div>

            <div style=" color: #b91c1c; padding: 10px; border-radius: 8px; margin-bottom: 20px;">
                ${requestScope.ERROR}
            </div>

            <div class="table">
                <%-- Giữ nguyên logic hiển thị bảng --%>
                <c:if test="${requestScope.LIST_USER != null}">
                    <c:if test="${not empty requestScope.LIST_USER}">
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
                                <c:forEach var="user" varStatus="counter" items="${requestScope.LIST_USER}">
                                <form action="MainController" method="POST">
                                    <tr>
                                        <td>${counter.count}</td>
                                        <td>
                                            <input type="text" name="userID" value="${user.userID}" readonly="" style="border:none; border-bottom: none; color: #64748b; font-weight: 600;"/>
                                        </td>
                                        <td>
                                            <input type="text" name="fullName" value="${user.fullName}" required=""/>
                                        </td>
                                        <td>
                                            <input type="text" name="roleID" value="${user.roleID}" required="" style="width: 50px; text-align: center;"/>
                                        </td>
                                        <td>${user.password}</td> <td>
                                            <input type="submit" value="Update" name="action" />
                                            <input type="hidden" name="txtSearchValue" value="${param.txtSearchValue}" />
                                        </td>
                                        <td>
                                            <c:url var="deleteLink" value="MainController">
                                                <c:param name="action" value="Delete"/>
                                                <c:param name="userID" value="${user.userID}"/>
                                                <c:param name="txtSearchValue" value="${param.txtSearchValue}"/>
                                            </c:url>
                                            <a href="${deleteLink}">Delete</a>
                                        </td>
                                    </tr>
                                </form>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                </c:if>

                <%-- Pagination giữ nguyên logic, class css đã được update --%>
                <div class="pagination">
                    <c:set var="endPage" value="${requestScope.endPage != null ? requestScope.endPage : 0}"/>
                    <c:set var="currentPage" value="${requestScope.currentPage != null ? requestScope.currentPage : 1}"/>
                    <c:set var="searchValue" value="${param.txtSearchValue}"/>

                    <c:if test="${endPage > 1}">
                        <c:if test="${currentPage > 1}">
                            <a href="MainController?action=Search&index=${currentPage - 1}&txtSearchValue=${searchValue}">&laquo;</a>
                        </c:if>

                        <c:forEach begin="1" end="${endPage}" var="i">
                            <c:choose>
                                <c:when test="${currentPage == i}">
                                    <a href="MainController?action=Search&index=${i}&txtSearchValue=${searchValue}" class="active">${i}</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="MainController?action=Search&index=${i}&txtSearchValue=${searchValue}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:if test="${currentPage < endPage}">
                            <a href="MainController?action=Search&index=${currentPage + 1}&txtSearchValue=${searchValue}">&raquo;</a>
                        </c:if>
                    </c:if>
                </div>
            </div>
        </div>
    </body>
</html>
