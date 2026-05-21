-- Demo seed for Hooklight dashboards.
-- Inserts a coherent dataset for campaigns, participants, and events.
-- Safe to run after sql/demo/reset_demo.sql.

BEGIN;

-- Safety: ensure expected columns/constraints exist in older databases.
ALTER TABLE participants
  ADD COLUMN IF NOT EXISTS province TEXT,
  ADD COLUMN IF NOT EXISTS department TEXT,
  ADD COLUMN IF NOT EXISTS consent BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS name TEXT,
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT NOW();

ALTER TABLE campaigns
  ADD COLUMN IF NOT EXISTS name TEXT,
  ADD COLUMN IF NOT EXISTS description TEXT,
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE,
  ADD COLUMN IF NOT EXISTS start_date TIMESTAMPTZ NULL,
  ADD COLUMN IF NOT EXISTS end_date TIMESTAMPTZ NULL;

ALTER TABLE events
  DROP CONSTRAINT IF EXISTS events_event_type_check;

ALTER TABLE events
  ADD CONSTRAINT events_event_type_check
  CHECK (event_type IN ('sent', 'open', 'click'));

-- Participants
INSERT INTO participants (id, name, email, consent, province, department, created_at)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'Ana Perez', 'ana.perez@demo.hooklight.local', true, 'Mendoza', 'Capital', NOW() - INTERVAL '70 days'),
  ('00000000-0000-0000-0000-000000000002', 'Bruno Diaz', 'bruno.diaz@demo.hooklight.local', true, 'Mendoza', 'Godoy Cruz', NOW() - INTERVAL '70 days'),
  ('00000000-0000-0000-0000-000000000003', 'Carla Lopez', 'carla.lopez@demo.hooklight.local', true, 'Mendoza', 'Guaymallen', NOW() - INTERVAL '69 days'),
  ('00000000-0000-0000-0000-000000000004', 'Diego Ruiz', 'diego.ruiz@demo.hooklight.local', true, 'Mendoza', 'Maipu', NOW() - INTERVAL '69 days'),
  ('00000000-0000-0000-0000-000000000005', 'Elena Torres', 'elena.torres@demo.hooklight.local', true, 'Mendoza', 'Lujan de Cuyo', NOW() - INTERVAL '68 days'),
  ('00000000-0000-0000-0000-000000000006', 'Fabian Sosa', 'fabian.sosa@demo.hooklight.local', true, 'Mendoza', 'Las Heras', NOW() - INTERVAL '68 days'),
  ('00000000-0000-0000-0000-000000000007', 'Gina Ferreyra', 'gina.ferreyra@demo.hooklight.local', true, 'Mendoza', 'San Martin', NOW() - INTERVAL '67 days'),
  ('00000000-0000-0000-0000-000000000008', 'Hector Vega', 'hector.vega@demo.hooklight.local', true, 'Mendoza', 'Tunuyan', NOW() - INTERVAL '67 days'),
  ('00000000-0000-0000-0000-000000000009', 'Irene Navas', 'irene.navas@demo.hooklight.local', true, 'Mendoza', 'Tupungato', NOW() - INTERVAL '66 days'),
  ('00000000-0000-0000-0000-000000000010', 'Jorge Arce', 'jorge.arce@demo.hooklight.local', true, 'Mendoza', 'Rivadavia', NOW() - INTERVAL '66 days'),
  ('00000000-0000-0000-0000-000000000011', 'Karen Luna', 'karen.luna@demo.hooklight.local', true, 'Mendoza', 'Junin', NOW() - INTERVAL '65 days'),
  ('00000000-0000-0000-0000-000000000012', 'Leo Molina', 'leo.molina@demo.hooklight.local', true, 'Mendoza', 'San Rafael', NOW() - INTERVAL '65 days'),
  ('00000000-0000-0000-0000-000000000013', 'Mara Quiroga', 'mara.quiroga@demo.hooklight.local', true, 'Mendoza', 'General Alvear', NOW() - INTERVAL '64 days'),
  ('00000000-0000-0000-0000-000000000014', 'Nicolas Ponce', 'nicolas.ponce@demo.hooklight.local', true, 'Mendoza', 'Lavalle', NOW() - INTERVAL '64 days'),
  ('00000000-0000-0000-0000-000000000015', 'Olga Prado', 'olga.prado@demo.hooklight.local', true, 'Mendoza', 'Malargue', NOW() - INTERVAL '63 days'),
  ('00000000-0000-0000-0000-000000000016', 'Pablo Cejas', 'pablo.cejas@demo.hooklight.local', true, 'Mendoza', 'Santa Rosa', NOW() - INTERVAL '63 days'),
  ('00000000-0000-0000-0000-000000000017', 'Quimey Soto', 'quimey.soto@demo.hooklight.local', true, 'Cordoba', 'Capital', NOW() - INTERVAL '62 days'),
  ('00000000-0000-0000-0000-000000000018', 'Rocio Gallo', 'rocio.gallo@demo.hooklight.local', true, 'Buenos Aires', 'La Plata', NOW() - INTERVAL '62 days'),
  ('00000000-0000-0000-0000-000000000019', 'Santiago Diaz', 'santiago.diaz@demo.hooklight.local', true, 'San Juan', 'Capital', NOW() - INTERVAL '61 days'),
  ('00000000-0000-0000-0000-000000000020', 'Tamara Vera', 'tamara.vera@demo.hooklight.local', true, 'Santa Fe', 'Rosario', NOW() - INTERVAL '61 days'),
  ('00000000-0000-0000-0000-000000000021', 'Ulises Marin', 'ulises.marin@demo.hooklight.local', false, 'Mendoza', 'Capital', NOW() - INTERVAL '60 days'),
  ('00000000-0000-0000-0000-000000000022', 'Valeria Gil', 'valeria.gil@demo.hooklight.local', true, 'Mendoza', 'Godoy Cruz', NOW() - INTERVAL '60 days'),
  ('00000000-0000-0000-0000-000000000023', 'Walter Orozco', 'walter.orozco@demo.hooklight.local', true, 'Mendoza', 'Guaymallen', NOW() - INTERVAL '59 days'),
  ('00000000-0000-0000-0000-000000000024', 'Ximena Paz', 'ximena.paz@demo.hooklight.local', true, 'Mendoza', 'Maipu', NOW() - INTERVAL '59 days')
ON CONFLICT (id) DO UPDATE
SET
  name = EXCLUDED.name,
  email = EXCLUDED.email,
  consent = EXCLUDED.consent,
  province = EXCLUDED.province,
  department = EXCLUDED.department;

-- Campaigns
INSERT INTO campaigns (id, name, description, created_at, is_active, start_date, end_date)
VALUES
  (
    'demo-camp-001',
    'Finanzas - Facturas urgentes',
    'Simulacion de urgencia con adjunto y CTA de validacion.',
    NOW() - INTERVAL '26 days',
    false,
    NOW() - INTERVAL '25 days',
    NOW() - INTERVAL '5 days'
  ),
  (
    'demo-camp-002',
    'RRHH - Actualizacion de beneficios',
    'Simulacion de enlace interno con vencimiento.',
    NOW() - INTERVAL '13 days',
    true,
    NOW() - INTERVAL '12 days',
    NULL
  ),
  (
    'demo-camp-003',
    'Operaciones - Enlace corto externo',
    'Simulacion historica para comparacion de periodos.',
    NOW() - INTERVAL '56 days',
    false,
    NOW() - INTERVAL '55 days',
    NOW() - INTERVAL '35 days'
  )
ON CONFLICT (id) DO UPDATE
SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  is_active = EXCLUDED.is_active,
  start_date = EXCLUDED.start_date,
  end_date = EXCLUDED.end_date;

-- Helper CTE for deterministic demo behavior
WITH u AS (
  SELECT
    id,
    row_number() OVER (ORDER BY email) AS rn
  FROM participants
  WHERE email LIKE '%@demo.hooklight.local'
),
sent_1 AS (
  SELECT
    id AS user_id,
    'demo-camp-001'::text AS campaign_id,
    'sent'::text AS event_type,
    NOW() - INTERVAL '24 days' + (rn * INTERVAL '20 minutes') AS event_time,
    '190.12.10.' || ((rn % 250) + 1)::text AS ip,
    CASE
      WHEN rn % 4 = 1 THEN 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'
      WHEN rn % 4 = 2 THEN 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 Safari/605.1.15'
      WHEN rn % 4 = 3 THEN 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:125.0) Gecko/20100101 Firefox/125.0'
      ELSE 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Edg/124.0'
    END AS user_agent,
    CASE
      WHEN rn <= 16 THEN 'AR'
      WHEN rn IN (17, 20) THEN 'CL'
      WHEN rn = 18 THEN 'UY'
      ELSE 'AR'
    END AS country
  FROM u
  WHERE rn <= 18
),
open_1 AS (
  SELECT
    id AS user_id,
    'demo-camp-001'::text AS campaign_id,
    'open'::text AS event_type,
    NOW() - INTERVAL '23 days' + (rn * INTERVAL '25 minutes') AS event_time,
    '190.12.20.' || ((rn % 250) + 1)::text AS ip,
    CASE
      WHEN rn % 3 = 0 THEN 'Mozilla/5.0 AppleWebKit/537.36 Chrome/124.0 Safari/537.36'
      WHEN rn % 3 = 1 THEN 'Mozilla/5.0 AppleWebKit/605.1.15 Safari/605.1.15'
      ELSE 'Mozilla/5.0 Gecko/20100101 Firefox/125.0'
    END AS user_agent,
    CASE
      WHEN rn <= 16 THEN 'AR'
      WHEN rn = 17 THEN 'CL'
      ELSE 'AR'
    END AS country
  FROM u
  WHERE rn <= 12
),
click_1 AS (
  SELECT
    id AS user_id,
    'demo-camp-001'::text AS campaign_id,
    'click'::text AS event_type,
    NOW() - INTERVAL '22 days' + (rn * INTERVAL '30 minutes') AS event_time,
    '190.12.30.' || ((rn % 250) + 1)::text AS ip,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36' AS user_agent,
    'AR' AS country
  FROM u
  WHERE rn IN (2, 4, 7, 11)
),
sent_2 AS (
  SELECT
    id AS user_id,
    'demo-camp-002'::text AS campaign_id,
    'sent'::text AS event_type,
    NOW() - INTERVAL '10 days' + (rn * INTERVAL '15 minutes') AS event_time,
    '181.44.10.' || ((rn % 250) + 1)::text AS ip,
    CASE
      WHEN rn % 4 = 1 THEN 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'
      WHEN rn % 4 = 2 THEN 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Edg/124.0'
      WHEN rn % 4 = 3 THEN 'Mozilla/5.0 AppleWebKit/605.1.15 Safari/605.1.15'
      ELSE 'Mozilla/5.0 Gecko/20100101 Firefox/125.0'
    END AS user_agent,
    CASE
      WHEN rn <= 17 THEN 'AR'
      WHEN rn = 18 THEN 'CL'
      WHEN rn = 19 THEN 'UY'
      ELSE 'AR'
    END AS country
  FROM u
  WHERE rn <= 20
),
open_2 AS (
  SELECT
    id AS user_id,
    'demo-camp-002'::text AS campaign_id,
    'open'::text AS event_type,
    NOW() - INTERVAL '9 days' + (rn * INTERVAL '18 minutes') AS event_time,
    '181.44.20.' || ((rn % 250) + 1)::text AS ip,
    CASE
      WHEN rn % 2 = 0 THEN 'Mozilla/5.0 AppleWebKit/537.36 Chrome/124.0 Safari/537.36'
      ELSE 'Mozilla/5.0 AppleWebKit/605.1.15 Safari/605.1.15'
    END AS user_agent,
    CASE
      WHEN rn <= 17 THEN 'AR'
      WHEN rn = 18 THEN 'CL'
      ELSE 'AR'
    END AS country
  FROM u
  WHERE rn <= 14
),
click_2 AS (
  SELECT
    id AS user_id,
    'demo-camp-002'::text AS campaign_id,
    'click'::text AS event_type,
    NOW() - INTERVAL '8 days' + (rn * INTERVAL '21 minutes') AS event_time,
    '181.44.30.' || ((rn % 250) + 1)::text AS ip,
    CASE
      WHEN rn % 2 = 0 THEN 'Mozilla/5.0 AppleWebKit/537.36 Chrome/124.0 Safari/537.36'
      ELSE 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Edg/124.0'
    END AS user_agent,
    CASE
      WHEN rn <= 17 THEN 'AR'
      ELSE 'CL'
    END AS country
  FROM u
  WHERE rn IN (2, 3, 5, 7, 11, 13)
),
sent_3 AS (
  SELECT
    id AS user_id,
    'demo-camp-003'::text AS campaign_id,
    'sent'::text AS event_type,
    NOW() - INTERVAL '50 days' + (rn * INTERVAL '14 minutes') AS event_time,
    '200.22.10.' || ((rn % 250) + 1)::text AS ip,
    CASE
      WHEN rn % 3 = 0 THEN 'Mozilla/5.0 AppleWebKit/537.36 Chrome/124.0 Safari/537.36'
      WHEN rn % 3 = 1 THEN 'Mozilla/5.0 Gecko/20100101 Firefox/125.0'
      ELSE 'Mozilla/5.0 AppleWebKit/605.1.15 Safari/605.1.15'
    END AS user_agent,
    'AR' AS country
  FROM u
  WHERE rn <= 16
),
open_3 AS (
  SELECT
    id AS user_id,
    'demo-camp-003'::text AS campaign_id,
    'open'::text AS event_type,
    NOW() - INTERVAL '49 days' + (rn * INTERVAL '17 minutes') AS event_time,
    '200.22.20.' || ((rn % 250) + 1)::text AS ip,
    'Mozilla/5.0 AppleWebKit/537.36 Chrome/124.0 Safari/537.36' AS user_agent,
    'AR' AS country
  FROM u
  WHERE rn <= 10
),
click_3 AS (
  SELECT
    id AS user_id,
    'demo-camp-003'::text AS campaign_id,
    'click'::text AS event_type,
    NOW() - INTERVAL '48 days' + (rn * INTERVAL '19 minutes') AS event_time,
    '200.22.30.' || ((rn % 250) + 1)::text AS ip,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Edg/124.0' AS user_agent,
    'AR' AS country
  FROM u
  WHERE rn IN (1, 3, 6, 8, 10)
)
INSERT INTO events (user_id, campaign_id, event_type, event_time, ip, user_agent, country)
SELECT * FROM sent_1
UNION ALL
SELECT * FROM open_1
UNION ALL
SELECT * FROM click_1
UNION ALL
SELECT * FROM sent_2
UNION ALL
SELECT * FROM open_2
UNION ALL
SELECT * FROM click_2
UNION ALL
SELECT * FROM sent_3
UNION ALL
SELECT * FROM open_3
UNION ALL
SELECT * FROM click_3
ORDER BY event_time;

COMMIT;
