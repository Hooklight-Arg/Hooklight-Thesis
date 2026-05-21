-- Total de eventos por tipo
SELECT event_type, COUNT(*) AS total
FROM events
GROUP BY event_type -- Agrupa por sent, open y click
ORDER BY event_type;
