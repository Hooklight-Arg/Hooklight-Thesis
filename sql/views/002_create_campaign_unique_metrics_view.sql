-- Vista: métricas únicas por campaña (más confiables que los open totales)
CREATE OR REPLACE VIEW campaign_unique_metrics AS
SELECT 
  campaign_id,
  COUNT(DISTINCT CASE WHEN event_type = 'open' THEN user_id END) AS opens_unicos,
  COUNT(DISTINCT CASE WHEN event_type = 'click' THEN user_id END) AS clicks_unicos,
  ROUND(
    COUNT(DISTINCT CASE WHEN event_type = 'click' THEN user_id END) * 100.0 /
    NULLIF(COUNT(DISTINCT CASE WHEN event_type = 'open' THEN user_id END), 0),
    2
  ) AS tasa_vulnerabilidad
FROM events
GROUP BY campaign_id;
