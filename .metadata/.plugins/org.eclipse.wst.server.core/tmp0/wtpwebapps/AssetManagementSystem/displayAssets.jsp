<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Asset Management System</title>
    <style>
        :root { --primary: #0078d4; --success: #28a745; --bg: #f4f7f6; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: var(--bg); margin: 0; padding: 20px; }
        .container { max-width: 1000px; margin: auto; }
        
        /* Alert Box */
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 4px; text-align: center; font-weight: bold; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        
        /* Form Styling */
        .card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .form-row { display: flex; gap: 10px; flex-wrap: wrap; }
        input, select { padding: 12px; border: 1px solid #ccc; border-radius: 4px; flex: 1; min-width: 150px; }
        button { background: var(--success); color: white; border: none; padding: 12px 25px; border-radius: 4px; cursor: pointer; transition: 0.3s; }
        button:hover { background: #218838; transform: translateY(-1px); }

        /* Status Badges */
        .badge { padding: 5px 10px; border-radius: 12px; font-size: 0.85em; font-weight: bold; }
        .available { background: #e1f5fe; color: #0288d1; }
        .allocated { background: #fff3e0; color: #ef6c00; }

        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        th { background: var(--primary); color: white; padding: 15px; text-align: left; }
        td { padding: 15px; border-bottom: 1px solid #eee; }
        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #f9f9f9; }
    </style>
</head>
<body>
<div class="container">
    <h1 style="color: #333; text-align: center;">🏢 Asset Core</h1>

    <%-- Success Message Logic --%>
    <% if ("success".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success">✅ Asset added successfully to the inventory!</div>
    <% } %>

    <div class="card">
        <h3>Register New Asset</h3>
        <form action="AssetServlet" method="POST" class="form-row">
            <input type="text" name="assetName" placeholder="Asset Name (e.g., MacBook Pro)" required>
            
            <select name="category">
                <option value="Hardware">Hardware</option>
                <option value="Software">Software</option>
                <option value="Network">Network</option>
            </select>

            <%-- New Status Dropdown --%>
            <select name="status">
                <option value="Available">Available</option>
                <option value="Allocated">Allocated</option>
                <option value="Maintenance">Maintenance</option>
            </select>

            <button type="submit">Add to Records</button>
        </form>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Asset Name</th>
                <th>Category</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
        <% 
            List<Map<String, String>> assets = (List<Map<String, String>>) request.getAttribute("assets");
            if (assets != null && !assets.isEmpty()) {
                for (Map<String, String> asset : assets) {
                    String statusClass = asset.get("status").toLowerCase();
        %>
        <tr>
            <td>#<%= asset.get("id") %></td>
            <td style="font-weight: 500;"><%= asset.get("name") %></td>
            <td><%= asset.get("category") %></td>
            <td>
                <span class="badge <%= statusClass %>"><%= asset.get("status") %></span>
            </td>
        </tr>
        <% 
                }
            } else {
        %>
        <tr><td colspan="4" style="text-align:center; color: #888;">No assets found. Start by adding one above.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>
</body>
</html>