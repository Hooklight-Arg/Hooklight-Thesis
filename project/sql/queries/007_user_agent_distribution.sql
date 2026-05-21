-- Distribución por agente de usuario/navegador mas frecuente
SELECT 
  user_agent,
  COUNT(*) AS total
FROM events
GROUP BY user_agent
ORDER BY total DESC
LIMIT 10;