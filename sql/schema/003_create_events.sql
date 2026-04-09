-- Crea la tabla de eventos normalizada
-- Relaciona participantes y campañas mediante user_id y campaign_id

CREATE TABLE IF NOT EXISTS events (
  id SERIAL PRIMARY KEY, -- SERIAL: autoincremental
  user_id UUID, -- UUID del participante asociado al evento
  campaign_id TEXT, -- ID de la campaña asociada
  event_type TEXT NOT NULL CHECK (event_type IN ('open', 'click')), -- Tipo de evento obligatorio y restringido a open o click
  event_time TIMESTAMP DEFAULT NOW(), -- Fecha/hora del evento
  ip TEXT, -- IP desde la cual llegó la interacción
  user_agent TEXT, -- Navegador o cliente de correo
  country TEXT, -- País detectado por Cloudflare
  CONSTRAINT fk_events_participant -- Define una clave foránea hacia participants(id)
    FOREIGN KEY (user_id) REFERENCES participants(id)
    ON DELETE SET NULL, -- Si se borra un participante, los eventos no se borran: el user_id queda en NULL
  CONSTRAINT fk_events_campaign -- Define una clave foránea hacia campaigns(id)
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
    ON DELETE SET NULL -- Si se borra la campaña, el evento permanece, pero la referencia queda nula
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_events_user_id ON events(user_id); -- Acelera búsquedas por usuario
CREATE INDEX IF NOT EXISTS idx_events_campaign_id ON events(campaign_id); -- Acelera metricas por campaña
CREATE INDEX IF NOT EXISTS idx_events_event_type ON events(event_type); -- Acelera filtros por open o click
CREATE INDEX IF NOT EXISTS idx_events_event_time ON events(event_time); -- Acelera analisis temporales
