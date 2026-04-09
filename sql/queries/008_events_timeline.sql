-- Evolución temporal de eventos por fecha y tipo
SELECT
  DATE(event_time) AS fecha, -- Toma solo la fecha, sin hora
  event_type, -- Distingue open y click
  COUNT(*) AS total -- Cuenta eventos
FROM events
GROUP BY DATE(event_time), event_type -- Agrupa por fecha y tipo
ORDER BY fecha, event_type;