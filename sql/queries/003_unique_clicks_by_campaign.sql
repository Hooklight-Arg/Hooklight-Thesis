-- Cuenta cuantos usuarios únicos y distintos hicieron click por campaña
SELECT 
  campaign_id,
  COUNT(DISTINCT user_id) AS usuarios_que_hicieron_click -- Usuarios únicos, no eventos duplicados
FROM events
WHERE event_type = 'click'
GROUP BY campaign_id
ORDER BY campaign_id;
