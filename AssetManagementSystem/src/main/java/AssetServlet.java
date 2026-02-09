

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class AssetServlet
 */
@WebServlet("/AssetServlet")
public class AssetServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AssetServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// List to hold asset records
	    java.util.List<java.util.Map<String, String>> assetList = new java.util.ArrayList<>();
	    String searchKeyword = request.getParameter("search");
	    
	    try {
	        // 1. Load MySQL Driver
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        
	        // 2. Connect to Database
	        java.sql.Connection conn = java.sql.DriverManager.getConnection(
	            "jdbc:mysql://localhost:3306/AssetDB", "root", "root");
	        
	     // Dynamic SQL Query
	        String sql = "SELECT * FROM assets";
	        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
	            sql += " WHERE asset_name LIKE ?";
	        }
	        
	        java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
	        
	        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
	            pstmt.setString(1, "%" + searchKeyword + "%");
	        }
	        // 3. Execute Query
	        
	        java.sql.ResultSet rs = pstmt.executeQuery();
	        

	        while (rs.next()) {
	            java.util.Map<String, String> asset = new java.util.HashMap<>();
	            asset.put("id", rs.getString("id"));
	            asset.put("name", rs.getString("asset_name"));
	            asset.put("category", rs.getString("category"));
	            asset.put("status", rs.getString("status"));
	            assetList.add(asset);
	        }
	        
	        if (rs != null) rs.close();
	        if (pstmt != null) pstmt.close();
	        conn.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    // 4. Pass data to JSP and forward
	    request.setAttribute("assets", assetList);
	    request.getRequestDispatcher("displayAssets.jsp").forward(request, response);
//		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
	    
	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        java.sql.Connection conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/AssetDB", "root", "root");

	        if ("delete".equals(action)) {
	            // DELETE LOGIC
	            String id = request.getParameter("assetId");
	            String sql = "DELETE FROM assets WHERE id = ?";
	            java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, Integer.parseInt(id));
	            pstmt.executeUpdate();
	            response.sendRedirect("AssetServlet?msg=deleted");
	        } else {
	            // ADD LOGIC
	            String name = request.getParameter("assetName");
	            String category = request.getParameter("category");
	            String status = request.getParameter("status");
	            
	            if (name == null || name.trim().isEmpty()) {
	                response.sendRedirect("AssetServlet?msg=invalid");
	                return;
	            }

	            String sql = "INSERT INTO assets (asset_name, category, status) VALUES (?, ?, ?)";
	            java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, name);
	            pstmt.setString(2, category);
	            pstmt.setString(3, status);
	            pstmt.executeUpdate();
	            response.sendRedirect("AssetServlet?msg=success");
	        }
	        conn.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.sendRedirect("AssetServlet?msg=error");
	    }

//		doGet(request, response);
	}

}
