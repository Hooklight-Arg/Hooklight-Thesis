-- Cuantos usuarios únicos abrieron el correo por campaña
SELECT 
  campaign_id,
  COUNT(DISTINCT user_id) AS usuarios_que_abrieron
FROM events
WHERE event_type = 'open'
GROUP BY campaign_id
ORDER BY campaign_id;
