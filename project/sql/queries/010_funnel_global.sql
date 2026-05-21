-- Embudo global del sistema (usuarios unicos)
SELECT
  COUNT(DISTINCT CASE WHEN event_type = 'sent' THEN user_id END) AS sent_unicos,
  COUNT(DISTINCT CASE WHEN event_type = 'open' THEN user_id END) AS opens_unicos,
  COUNT(DISTINCT CASE WHEN event_type = 'click' THEN user_id END) AS clicks_unicos,
  ROUND(
    COUNT(DISTINCT CASE WHEN event_type = 'open' THEN user_id END) * 100.0 /
    NULLIF(COUNT(DISTINCT CASE WHEN event_type = 'sent' THEN user_id END), 0),
    2
  ) AS open_rate_unico_percent,
  ROUND(
    COUNT(DISTINCT CASE WHEN event_type = 'click' THEN user_id END) * 100.0 /
    NULLIF(COUNT(DISTINCT CASE WHEN event_type = 'open' THEN user_id END), 0),
    2
  ) AS click_to_open_unico_percent
FROM events;
