-- Distribución por departamento de Mendoza
-- Cuenta eventos y participantes únicos por departamento

SELECT
  COALESCE(NULLIF(TRIM(p.department), ''), 'N/A') AS departamento,
  COUNT(*) AS total_eventos,
  COUNT(*) FILTER (WHERE e.event_type = 'sent')  AS sent,
  COUNT(*) FILTER (WHERE e.event_type = 'open')  AS opens,
  COUNT(*) FILTER (WHERE e.event_type = 'click') AS clicks,
  COUNT(DISTINCT e.user_id) AS participantes_unicos
FROM events e
JOIN participants p ON p.id = e.user_id
WHERE p.province ILIKE 'Mendoza'
GROUP BY 1
ORDER BY total_eventos DESC;
