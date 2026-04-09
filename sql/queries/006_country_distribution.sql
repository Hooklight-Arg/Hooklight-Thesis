-- Distribución (cantidad) de eventos por país
SELECT 
  country,
  COUNT(*) AS total
FROM events
GROUP BY country
ORDER BY total DESC, country; -- Primero los países con más eventos