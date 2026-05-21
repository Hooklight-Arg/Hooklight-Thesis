-- Vista: distribución de eventos por país
CREATE OR REPLACE VIEW event_country_distribution AS
SELECT 
  country,
  COUNT(*) AS total_eventos
FROM events
GROUP BY country;
