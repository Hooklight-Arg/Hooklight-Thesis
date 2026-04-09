-- Cruce detallado entre eventos, participantes y campañas
SELECT 
  e.id,
  e.event_time,
  e.event_type,
  e.user_id,
  p.name,
  p.email,
  e.campaign_id,
  c.name AS campaign_name,
  e.ip,
  e.country,
  e.user_agent
FROM events e -- Tabla principal, con alias e
LEFT JOIN participants p ON e.user_id = p.id -- Une eventos con participantes
LEFT JOIN campaigns c ON e.campaign_id = c.id -- Une eventos con campañas
-- Usamos LEFT JOIN porque aunque falte el participante o campaña, el evento igual aparece
ORDER BY e.event_time DESC, e.id DESC; -- Primero los eventos mas recientes