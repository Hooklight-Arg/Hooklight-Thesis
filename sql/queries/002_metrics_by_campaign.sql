-- Calcula aperturas, clicks y click rate (tasa de clicks) por campaña
SELECT 
  campaign_id,
  COUNT(*) FILTER (WHERE event_type = 'open') AS opens, -- Cuenta solo eventos open
  COUNT(*) FILTER (WHERE event_type = 'click') AS clicks, -- Cuenta solo eventos click
  ROUND( -- Calcula porcentaje de clics sobre aperturas:
    COUNT(*) FILTER (WHERE event_type = 'click') * 100.0 /
    NULLIF(COUNT(*) FILTER (WHERE event_type = 'open'), 0),
    2
  ) AS click_rate_percent
FROM events
GROUP BY campaign_id -- Una fila por campaña
ORDER BY campaign_id; -- Ordenado por ID de campaña
