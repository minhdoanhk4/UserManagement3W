/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fa3w.users;

import fa3w.utils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author msi2k
 */
public class UserDAO {

//    private static final String LOGIN = "SELECT userID, fullName, roleID " // Sửa: Thêm dấu ngoặc kép
//            + "FROM tblUsers " // Sửa: Thêm dấu ngoặc kép
//            + "WHERE userID = ? and password = ?";
    private static final String LOGIN = "SELECT \"userID\", \"fullName\", \"roleID\" "
            + "FROM \"tblUsers\" "
            + "WHERE LOWER(\"userID\") = LOWER(?) AND \"password\" = ?";

    public UserDTO checkLogin(String userID, String password) throws SQLException, ClassNotFoundException {
        UserDTO user = null;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {

                System.out.println("DEBUG: Đang chuẩn bị query...");
                System.out.println("DEBUG: SQL: " + LOGIN);

                ptm = conn.prepareStatement(LOGIN);
                ptm.setString(1, userID);
                ptm.setString(2, password);
                try {
                    rs = ptm.executeQuery();
                    System.out.println("DEBUG: Query thành công!"); // Nếu không thấy dòng này là lỗi
                } catch (SQLException ex) {
                    System.out.println("!!! LỖI SQL NGHIÊM TRỌNG !!!");
                    ex.printStackTrace(); // Quan trọng: Xem lỗi chi tiết ở đây
                    throw ex; // Ném lỗi ra ngoài để controller biết
                }
                if (rs.next()) {
                    String realUserID = rs.getString("userID");
                    String fullName = rs.getString("fullName");
                    String roleID = rs.getString("roleID");
                    user = new UserDTO(realUserID, fullName, roleID, "***");
                }
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return user;
    }

    private static final String DEFAULT_ROLE = "US";
    private static final String GOOGLE_PASSWORD_PLACEHOLDER = "1";
    private static final String CHECK_ACCOUNT = "SELECT \"fullName\", \"password\", \"roleID\" "
            + "FROM \"tblUsers\" "
            + "WHERE \"userID\" = ?";
    private static final String CREATE_ACCOUNT = "INSERT INTO \"tblUsers\" (\"userID\", \"fullName\", \"password\", \"roleID\") "
            + "VALUES (?, ?, ?, ?)";

    public UserDTO checkAndCreateGoogleUser(String userID, String fullName) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        UserDTO user = null;

        conn = DBUtils.getConnection();
        if (conn != null) {
            // 1. Kiểm tra người dùng đã tồn tại chưa
            ptm = conn.prepareStatement(CHECK_ACCOUNT);
            ptm.setString(1, userID);
            rs = ptm.executeQuery();

            if (rs.next()) {
                // Người dùng đã tồn tại
                String roleID = rs.getString("roleID");
                String password = rs.getString("password");
                user = new UserDTO(userID, fullName, roleID, "***");
            } else {
                // 2. Người dùng CHƯA tồn tại -> Tự động ĐĂNG KÝ
                ptm = conn.prepareStatement(CREATE_ACCOUNT);
                ptm.setString(1, userID);
                ptm.setString(2, fullName);
                ptm.setString(3, GOOGLE_PASSWORD_PLACEHOLDER);
                ptm.setString(4, DEFAULT_ROLE);

                int result = ptm.executeUpdate();

                if (result > 0) {
                    // Tạo đối tượng DTO cho người dùng mới
                    user = new UserDTO(userID, fullName, DEFAULT_ROLE, "***");
                }
            }
        }
        if (rs != null) {
            rs.close();
        }
        if (ptm != null) {
            ptm.close();
        }
        if (conn != null) {
            conn.close();
        }
        return user;
    }

    private static final String SEARCH = "SELECT \"userID\", \"fullName\", \"roleID\" "
            + "FROM \"tblUsers\" "
            + "WHERE \"fullName\" ILIKE ?";

    public List<UserDTO> getListUser(String search) throws ClassNotFoundException, SQLException {
        List<UserDTO> listUser = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(SEARCH);
                ptm.setString(1, "%" + search + "%");
                rs = ptm.executeQuery();
                while (rs.next()) {
                    String userID = rs.getString("userID");
                    String fullName = rs.getString("fullName");
                    String roleID = rs.getString("roleID");
                    String password = "***";
                    listUser.add(new UserDTO(userID, fullName, roleID, password));
                }
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return listUser;
    }

    private static final String UPDATE = "UPDATE \"tblUsers\" "
            + "SET \"fullName\" = ?, \"roleID\" = ? "
            + "WHERE \"userID\" = ?";

    public boolean updateUser(UserDTO user)
            throws ClassNotFoundException, SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(UPDATE);
                ptm.setString(1, user.getFullName());
                ptm.setString(2, user.getRoleID());
                ptm.setString(3, user.getUserID());
                check = ptm.executeUpdate() > 0 ? true : false;

            }
        } finally {
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

    private static final String DELETE = "DELETE FROM \"tblUsers\" "
            + "WHERE \"userID\" = ?";
    private static final String DELETE_ORDER_DETAIL = "DELETE FROM \"tblOrderDetail\" "
            + "WHERE \"userID\" = ?";
    private static final String DELETE_ORDER = "DELETE FROM \"tblOrder\" "
            + "WHERE \"userID\" = ?";

    public boolean deleteUser(String user)
            throws ClassNotFoundException, SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                // 1. Bắt đầu Transaction để đảm bảo xóa sạch hoặc không xóa gì cả
                conn.setAutoCommit(false); 

                // BƯỚC 1: Xóa chi tiết đơn hàng trước (Bảng con nhỏ nhất)
                ptm = conn.prepareStatement(DELETE_ORDER_DETAIL);
                ptm.setString(1, user);
                ptm.executeUpdate();
                ptm.close(); // Đóng statement để tái sử dụng biến

                // BƯỚC 2: Xóa đơn hàng (Bảng con)
                ptm = conn.prepareStatement(DELETE_ORDER);
                ptm.setString(1, user);
                ptm.executeUpdate();
                ptm.close();

                // BƯỚC 3: Xóa User (Bảng cha) - Giờ mới xóa được
                ptm = conn.prepareStatement(DELETE);
                ptm.setString(1, user);
                check = ptm.executeUpdate() > 0;
                
                // 2. Xác nhận Transaction thành công
                conn.commit();
            }
        } catch (Exception e) {
            // 3. Nếu có lỗi thì hoàn tác (Rollback)
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return check;
    }

    private static final String CREATE = "INSERT INTO \"tblUsers\"(\"userID\", \"fullName\", \"roleID\", \"password\") "
            + "VALUES(?,?,?,?)";

    public boolean insertUserV2(UserDTO user) throws SQLException, ClassNotFoundException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(CREATE);
                ptm.setString(1, user.getUserID());
                ptm.setString(2, user.getFullName());
                ptm.setString(3, user.getRoleID());
                ptm.setString(4, user.getPassword());
                check = ptm.executeUpdate() > 0 ? true : false;
            }
        } finally {
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

    private static final String CHECK_DUPLICATE = "SELECT \"userID\" FROM \"tblUsers\" WHERE LOWER(\"userID\") = LOWER(?)";

    public boolean checkDuplicate(String userID) throws ClassNotFoundException, SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(CHECK_DUPLICATE);
                ptm.setString(1, userID);
                rs = ptm.executeQuery();
                if (rs.next()) {
                    check = true; // Đã tồn tại
                }
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

}
