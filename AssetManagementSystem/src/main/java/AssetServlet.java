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
       
    public AssetServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    java.util.List<java.util.Map<String, String>> assetList = new java.util.ArrayList<>();
	    String searchKeyword = request.getParameter("search");
	    
	 // Dashboard counters
        int availableCount = 0;
        int allocatedCount = 0;
        int maintenanceCount = 0;
	    
	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        java.sql.Connection conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/AssetDB", "root", "root");
	        
	        String sql = "SELECT * FROM assets";
	        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
	            sql += " WHERE asset_name LIKE ?";
	        }
	        
	        java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
	        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
	            pstmt.setString(1, "%" + searchKeyword + "%");
	        }
	        
	        java.sql.ResultSet rs = pstmt.executeQuery();
	        while (rs.next()) {
	            java.util.Map<String, String> asset = new java.util.HashMap<>();
	            String status = rs.getString("status");
	            asset.put("id", rs.getString("id"));
	            asset.put("name", rs.getString("asset_name"));
	            asset.put("category", rs.getString("category"));
	            asset.put("status", status);
	            assetList.add(asset);
	            
	         // Update dashboard counters
                if ("Available".equalsIgnoreCase(status)) availableCount++;
                else if ("Allocated".equalsIgnoreCase(status)) allocatedCount++;
                else if ("Maintenance".equalsIgnoreCase(status)) maintenanceCount++;
	        }
	        
	        rs.close();
	        pstmt.close();
	        conn.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	 // Pass data to JSP
        request.setAttribute("assets", assetList);
        request.setAttribute("availableCount", availableCount);
        request.setAttribute("allocatedCount", allocatedCount);
        request.setAttribute("maintenanceCount", maintenanceCount);
        request.getRequestDispatcher("displayAssets.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
	    
	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        java.sql.Connection conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/AssetDB", "root", "root");

	        if ("delete".equals(action)) {
	            String id = request.getParameter("assetId");
	            String sql = "DELETE FROM assets WHERE id = ?";
	            java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, Integer.parseInt(id));
	            pstmt.executeUpdate();
	            pstmt.close();
	            response.sendRedirect("AssetServlet?msg=deleted");
	        } else if ("update".equals(action)) {
	            // UPDATE LOGIC
	            String id = request.getParameter("assetId");
	            String name = request.getParameter("assetName");
	            String category = request.getParameter("category");
	            String status = request.getParameter("status");

	            String sql = "UPDATE assets SET asset_name = ?, category = ?, status = ? WHERE id = ?";
	            java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, name);
	            pstmt.setString(2, category);
	            pstmt.setString(3, status);
	            pstmt.setInt(4, Integer.parseInt(id));
	            
	            pstmt.executeUpdate();
	            pstmt.close();
	            response.sendRedirect("AssetServlet?msg=updated");
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
	            pstmt.close();
	            response.sendRedirect("AssetServlet?msg=success");
	        }
	        conn.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.sendRedirect("AssetServlet?msg=error");
	    }
	}
}