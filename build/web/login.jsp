<%-- 
    Document   : login
    Created on : Dec 2, 2025, 7:52:54 AM
    Author     : msi2k
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>LOGIN PAGE</title>
        <link rel="stylesheet" href="css/loginStyle.css"/>
        <script src="https://accounts.google.com/gsi/client" async defer></script>
        <script src="script/loginJs.js"></script>
        <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    </head>
    <body>
        <%-- Giữ nguyên logic xử lý error --%>
        <%
            String error = (String) request.getAttribute("ERROR");
            if (error == null)
                error = "";
        %>
        <div class="container">
            <div class="boxLogin">
                <h1>Welcome Back</h1>
                

                <form action="MainController" method="POST">
                    <div style="text-align: left;">
                        <p>User ID</p>
                        <input type="text" name="txtUserID" required="" placeholder="e.g. admin"/>

                        <p>Password</p>
                        <input type="password" name="txtPassword" required="" placeholder="••••••••"/>
                    </div>

                    <div class="captcha-container">
                        <div class="g-recaptcha" data-sitekey="6LfI_CEsAAAAAAtyYU9q44iS1M9E_yV4-jxZMQoD"></div>
                    </div>

                    <font><%= error%></font>

                    <div class="button">
                        <input type="submit" name="action" value="Login" />
                        <input type="reset" value="Reset"/>
                    </div>
                </form>

                <div class="social-login-wrapper">
                    <p style="text-align: center; font-size: 12px; margin-bottom: 10px;">Or continue with</p>
                    <div class="google-btn-wrap">
                        <%-- Giữ nguyên code Google Button --%>
                        <div id="g_id_onload"
                             data-client_id="780471524602-gn88fpdjcvd93meano38qvkuqrc0paqb.apps.googleusercontent.com" 
                             data-context="signin"
                             data-ux_mode="popup"
                             data-callback="handleCredentialResponse" 
                             data-auto_prompt="false">
                        </div>
                        <div class="g_id_signin"
                             data-type="standard"
                             data-shape="pill"
                             data-theme="outline"
                             data-text="continue_with"
                             data-size="large"
                             data-width="300" 
                             data-logo_alignment="center">
                        </div>
                    </div>
                </div>

                <%-- Giữ form ẩn --%>
                <form id="google-token-form" action="MainController" method="POST">
                    <input type="hidden" name="action" value="GoogleLogin" />
                    <input type="hidden" name="token" id="google-token-form-jwt" value="" />
                </form>

                <div style="margin-top: 20px; font-size: 13px;">
                    Don't have an account? <a href="MainController?action=SignUp">Sign up</a>
                </div>
            </div>
            <%-- Footer --%>
        </div>
    </body>
</html>
