<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Asset Management System | Dashboard</title>
    <style>
        :root {
            --primary: #2563eb;
            --secondary: #64748b;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #1e293b;
        }

        body {
            font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
            background-color: var(--bg);
            color: var(--text-main);
            line-height: 1.5;
            margin: 0;
            padding: 40px 20px;
        }

        .container {
            max-width: 1100px;
            margin: auto;
        }

        /* Modern Card UI */
        .card {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            margin-bottom: 2rem;
            border: 1px solid #e2e8f0;
        }

        h1, h3 { color: #0f172a; margin-top: 0; }

        /* Alert Box */
        .alert { padding: 1rem; margin-bottom: 1.5rem; border-radius: 8px; text-align: center; font-weight: 600; }
        .alert-success { background-color: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .alert-deleted { background-color: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-warning { background-color: #fef9c3; color: #854d0e; border: 1px solid #fef08a; }

        /* Form Layout */
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: end;
        }

        input, select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 0.95rem;
            box-sizing: border-box;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input:focus, select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        /* Buttons */
        .btn {
            font-weight: 600;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-primary { background: var(--primary); color: white; }
        .btn-primary:hover { background: #1d4ed8; transform: translateY(-1px); }
        
        .btn-warning { background: var(--warning); color: #000; }
        .btn-danger { background: #fee2e2; color: var(--danger); }
        .btn-danger:hover { background: var(--danger); color: white; }
        
        .btn-export { background: #166534; color: white; margin-top: 10px; }

        /* Table */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
            margin-top: 1rem;
        }

        th {
            background: #f1f5f9;
            color: var(--secondary);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
            padding: 1rem 1.5rem;
            text-align: left;
        }

        td { padding: 1rem 1.5rem; border-top: 1px solid #f1f5f9; }
        tr:hover td { background-color: #f8fafc; }

        /* Status Badges */
        .badge { padding: 0.35rem 0.75rem; border-radius: 9999px; font-size: 0.75rem; font-weight: 700; }
        .available { background: #dcfce7; color: #166534; }
        .allocated { background: #fef9c3; color: #854d0e; }
        .maintenance { background: #fee2e2; color: #991b1b; }

        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 300px;
            gap: 2rem;
            align-items: center;
        }

        @media (max-width: 768px) {
            .dashboard-grid { grid-template-columns: 1fr; }
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<div class="container">
    <h1 style="text-align: center; margin-bottom: 2rem;">🏢 Asset Core Management</h1>

    <%-- Feedback Messages --%>
    <% if ("success".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success">✅ Asset added successfully to inventory!</div>
    <% } else if ("updated".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-warning">📝 Asset details updated successfully!</div>
    <% } else if ("deleted".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-deleted">🗑️ Asset has been removed from records.</div>
    <% } else if ("invalid".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-warning">⚠️ Invalid input: Asset name cannot be empty.</div>
    <% } %>

    <%-- Registration & Edit Form --%>
    <div class="card">
        <h3 id="formTitle">Register New Asset</h3>
        <form action="AssetServlet" method="POST" class="form-row" id="assetForm">
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="assetId" id="assetId">
            
            <div>
                <label style="font-size: 0.85rem; font-weight: 600; color: var(--secondary);">Asset Name</label>
                <input type="text" name="assetName" id="assetName" placeholder="e.g. MacBook Pro" required>
            </div>
            
            <div>
                <label style="font-size: 0.85rem; font-weight: 600; color: var(--secondary);">Category</label>
                <select name="category" id="assetCategory">
                    <option value="Hardware">Hardware</option>
                    <option value="Software">Software</option>
                    <option value="Network">Network</option>
                </select>
            </div>

            <div>
                <label style="font-size: 0.85rem; font-weight: 600; color: var(--secondary);">Allocation Status</label>
                <select name="status" id="assetStatus">
                    <option value="Available">Available</option>
                    <option value="Allocated">Allocated</option>
                    <option value="Maintenance">Maintenance</option>
                </select>
            </div>

            <div style="display: flex; gap: 0.5rem;">
                <button type="submit" id="submitBtn" class="btn btn-primary">Add Asset</button>
                <button type="button" id="cancelBtn" class="btn" onclick="resetForm()" style="display:none; background:#64748b; color:white;">Cancel</button>
            </div>
        </form>
    </div>

    <%-- Search & Export Controls --%>
    <div style="display: flex; gap: 1rem; margin-bottom: 1.5rem; align-items: center; justify-content: space-between; flex-wrap: wrap;">
        <div class="card" style="flex: 1; margin-bottom: 0; padding: 1.5rem;">
            <form action="AssetServlet" method="GET" class="form-row">
                <input type="text" name="search" placeholder="Filter by asset name..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="btn btn-primary" style="background: var(--secondary);">🔍 Search</button>
                <a href="AssetServlet" class="btn" style="color: var(--secondary); border: 1px solid #cbd5e1;">Clear</a>
            </form>
        </div>
        <a href="ExportServlet" class="btn btn-export">📊 Export Excel (.xls)</a>
    </div>

    <%-- Asset Table --%>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Asset Name</th>
                <th>Category</th>
                <th>Status</th>
                <th style="text-align: right;">Actions</th>
            </tr>
        </thead>
        <tbody>
        <% 
            List<Map<String, String>> assets = (List<Map<String, String>>) request.getAttribute("assets");
            if (assets != null && !assets.isEmpty()) {
                for (Map<String, String> asset : assets) {
                    String status = asset.get("status");
                    String statusClass = (status != null) ? status.toLowerCase() : "available";
        %>
        <tr>
            <td style="color: var(--secondary); font-weight: 600;">#<%= asset.get("id") %></td>
            <td style="font-weight: 600;"><%= asset.get("name") %></td>
            <td><%= asset.get("category") %></td>
            <td><span class="badge <%= statusClass %>"><%= status %></span></td>
            <td style="text-align: right; display: flex; gap: 0.5rem; justify-content: flex-end;">
               <button type="button" class="btn btn-warning" style="padding: 0.5rem 1rem; font-size: 0.8rem;"
                       onclick="prepareEdit('<%= asset.get("id") %>', '<%= asset.get("name").replace("'", "\\'") %>', '<%= asset.get("category") %>', '<%= asset.get("status") %>')">
                   Edit
               </button>
               
               <form action="AssetServlet" method="POST" style="display:inline;" onsubmit="return confirm('Confirm deletion of this asset?');">
                 <input type="hidden" name="action" value="delete">
                 <input type="hidden" name="assetId" value="<%= asset.get("id") %>">
                 <button type="submit" class="btn btn-danger" style="padding: 0.5rem 1rem; font-size: 0.8rem;">Delete</button>
              </form>
            </td>
        </tr>
        <% } } else { %>
        <tr><td colspan="5" style="text-align:center; padding: 3rem; color: var(--secondary);">No assets found. Try adjusting your search or add a new one.</td></tr>
        <% } %>
        </tbody>
    </table>

    <%-- Dashboard Analytics --%>
    <div class="card" style="margin-top: 3rem;">
        <div class="dashboard-grid">
            <div>
                <h3>Inventory Insights</h3>
                <p style="color: var(--secondary);">Real-time distribution of organizational assets by status.</p>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-top: 1.5rem;">
                    <div style="background: #f1f5f9; padding: 1rem; border-radius: 8px;">
                        <span style="font-size: 0.85rem; color: var(--secondary);">Available</span>
                        <div style="font-size: 1.5rem; font-weight: 700;"><%= request.getAttribute("availableCount") %></div>
                    </div>
                    <div style="background: #f1f5f9; padding: 1rem; border-radius: 8px;">
                        <span style="font-size: 0.85rem; color: var(--secondary);">Allocated</span>
                        <div style="font-size: 1.5rem; font-weight: 700;"><%= request.getAttribute("allocatedCount") %></div>
                    </div>
                </div>
            </div>
            <div style="height: 250px; display: flex; justify-content: center;">
                <canvas id="statusChart"></canvas>
            </div>
        </div>
    </div>

    <footer style="text-align: center; color: var(--secondary); font-size: 0.85rem; margin-top: 2rem;">
        Asset Management System | Developed by Group 7
    </footer>
</div>

<script>
    // Initialize Chart.js
    const ctx = document.getElementById('statusChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Available', 'Allocated', 'Maintenance'],
            datasets: [{
                data: [
                    <%= request.getAttribute("availableCount") %>, 
                    <%= request.getAttribute("allocatedCount") %>, 
                    <%= request.getAttribute("maintenanceCount") %>
                ],
                backgroundColor: ['#10b981', '#f59e0b', '#ef4444'],
                hoverOffset: 4,
                borderWidth: 0
            }]
        },
        options: {
            cutout: '70%',
            responsive: true,
            plugins: {
                legend: { position: 'bottom', labels: { usePointStyle: true, padding: 20 } }
            }
        }
    });

    // Form Edit Logic
    function prepareEdit(id, name, category, status) {
        document.getElementById('formTitle').innerText = "Update Asset #" + id;
        document.getElementById('formAction').value = "update";
        document.getElementById('assetId').value = id;
        document.getElementById('assetName').value = name;
        document.getElementById('assetCategory').value = category;
        document.getElementById('assetStatus').value = status;
        document.getElementById('submitBtn').innerText = "Save Changes";
        document.getElementById('submitBtn').classList.replace('btn-primary', 'btn-warning');
        document.getElementById('cancelBtn').style.display = "inline-block";
        window.scrollTo({top: 0, behavior: 'smooth'});
    }

    function resetForm() {
        document.getElementById('formTitle').innerText = "Register New Asset";
        document.getElementById('formAction').value = "add";
        document.getElementById('assetForm').reset();
        document.getElementById('submitBtn').innerText = "Add Asset";
        document.getElementById('submitBtn').classList.replace('btn-warning', 'btn-primary');
        document.getElementById('cancelBtn').style.display = "none";
    }
</script>
</body>
</html>