-- Vista: métricas básicas por campaña
CREATE OR REPLACE VIEW campaign_metrics AS
SELECT 
  campaign_id,
  COUNT(*) FILTER (WHERE event_type = 'open') AS opens,
  COUNT(*) FILTER (WHERE event_type = 'click') AS clicks,
  ROUND(
    COUNT(*) FILTER (WHERE event_type = 'click') * 100.0 /
    NULLIF(COUNT(*) FILTER (WHERE event_type = 'open'), 0),
    2
  ) AS click_rate_percent
FROM events
GROUP BY campaign_id;
