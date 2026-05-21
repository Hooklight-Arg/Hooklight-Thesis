# Demo Reset + Seed Workflow

This folder contains scripts to safely prepare a clean demo dataset for Grafana.

## 1) Backup first (recommended)

From the project root:

```powershell
powershell -ExecutionPolicy Bypass -File .\sql\demo\backup_demo.ps1
```

Optional parameters:

```powershell
powershell -ExecutionPolicy Bypass -File .\sql\demo\backup_demo.ps1 -DbName phishing_awareness -DbUser postgres
```

## 2) Reset demo tables

Run in pgAdmin Query Tool (or psql):

```sql
\i sql/demo/reset_demo.sql
```

## 3) Seed demo data

Run:

```sql
\i sql/demo/seed_demo.sql
```

## Notes

- `reset_demo.sql` truncates only:
  - `events`
  - `campaigns`
  - `participants`
- Reference tables like `mendoza_departments_geo` are preserved.
- Seed data includes:
  - 24 participants
  - 3 campaigns
  - sent/open/click events across recent and previous periods
  - enough geographic/browser variation for dashboard storytelling
