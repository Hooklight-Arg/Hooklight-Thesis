-- Vista: distribución de eventos por user agent (navegador/cliente)
CREATE OR REPLACE VIEW event_user_agent_distribution AS
SELECT 
  user_agent,
  COUNT(*) AS total_eventos
FROM events
GROUP BY user_agent;
