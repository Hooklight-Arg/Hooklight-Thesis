-- Reset dataset for demo runs.
-- Keeps table structure, views, and reference tables.
-- IMPORTANT: Run a backup before this script.

BEGIN;

TRUNCATE TABLE
  events,
  campaigns,
  participants
RESTART IDENTITY CASCADE;

COMMIT;
