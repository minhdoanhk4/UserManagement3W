/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package fa3w.controllers;

import fa3w.users.UserDAO;
import fa3w.users.UserDTO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author msi2k
 */
@WebServlet(name = "DeleteController", urlPatterns = {"/DeleteController"})
public class DeleteController extends HttpServlet {

    private static final String SUCCESS = "SearchController";
    private static final String ERROR = "SearchController";
    private static final String DELETE_LOGIN = "Unavailable because you are logged into the system!?";
    private static final String DELETE_ERROR = "Delete fail!!!";
    private static final String SESSION_TIMEOUT = "Session timed out! Please login again.";
    
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR;
        try {
            String userID = request.getParameter("userID");
            UserDTO loginUser = (UserDTO) request.getSession().getAttribute("LOGIN_USER");

            // BƯỚC 1: KIỂM TRA SESSION TRƯỚC TIÊN
            // Nếu không có user đăng nhập, chặn ngay lập tức.
            if (loginUser == null) {
                request.setAttribute("ERROR", SESSION_TIMEOUT);
            } 
            // BƯỚC 2: KIỂM TRA TRÙNG ID (Xóa chính mình)
            // Sử dụng trim() và equalsIgnoreCase() để xử lý trường hợp "Admin" vs "admin"
            else if (loginUser.getUserID().trim().equalsIgnoreCase(userID.trim())) {
                request.setAttribute("ERROR", DELETE_LOGIN);
            } 
            // BƯỚC 3: THỰC HIỆN XÓA (Chỉ khi đã qua 2 bước trên)
            else {
                if (new UserDAO().deleteUser(userID)) {
                    url = SUCCESS;
                } else {
                    request.setAttribute("ERROR", DELETE_ERROR);
                }
            }
        } catch (Exception e) {
            log("Error at DeleteController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
