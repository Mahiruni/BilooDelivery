# Biloo Admin Dashboard

The dashboard is intentionally dependency-free in the foundation phase. Open `index.html` directly or serve the directory with any static server.

```bash
cd apps/admin_dashboard
python3 -m http.server 4173
```

The shell includes responsive navigation, operational KPIs, live-dispatch visualization, searchable orders, CSV export, vendor approvals, and placeholders for all major modules. Supabase query adapters and role-based access control are wired in the connected-backend phase.
