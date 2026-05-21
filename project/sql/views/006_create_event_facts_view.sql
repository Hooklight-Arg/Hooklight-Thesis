-- Vista canónica para dashboards ejecutivos de Hooklight
-- Objetivo: unificar parsing, cohortes y filtros reutilizables.

CREATE OR REPLACE VIEW event_facts AS
SELECT
  e.id,
  e.event_time,
  e.event_type,
  e.user_id,
  e.campaign_id,
  COALESCE(c.name, e.campaign_id) AS campaign_name,
  c.is_active AS campaign_is_active,
  c.start_date AS campaign_start_date,
  c.end_date AS campaign_end_date,
  COALESCE(NULLIF(TRIM(e.country), ''), 'N/A') AS country_norm,
  CASE
    WHEN e.user_agent ILIKE '%Edg%' THEN 'Edge'
    WHEN e.user_agent ILIKE '%Chrome%' THEN 'Chrome'
    WHEN e.user_agent ILIKE '%Firefox%' THEN 'Firefox'
    WHEN e.user_agent ILIKE '%Safari%' AND e.user_agent NOT ILIKE '%Chrome%' THEN 'Safari'
    WHEN e.user_agent ILIKE '%Opera%' OR e.user_agent ILIKE '%OPR/%' THEN 'Opera'
    ELSE 'Otro / N/A'
  END AS browser_family,
  e.user_agent,
  e.ip,
  p.email,
  p.consent,
  COALESCE(NULLIF(TRIM(p.province), ''), 'N/A') AS province_norm,
  COALESCE(NULLIF(TRIM(p.department), ''), 'N/A') AS department_norm,
  CASE
    WHEN c.start_date IS NOT NULL AND e.event_time < c.start_date - INTERVAL '1 day' THEN TRUE
    WHEN c.end_date IS NOT NULL AND e.event_time > c.end_date + INTERVAL '30 day' THEN TRUE
    ELSE FALSE
  END AS out_of_campaign_window
FROM events e
LEFT JOIN participants p ON p.id = e.user_id
LEFT JOIN campaigns c ON c.id = e.campaign_id;
