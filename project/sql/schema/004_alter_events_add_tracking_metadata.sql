-- Script incremental para adaptar una tabla `events` preexistente
-- Ejecutar solo si ya existe la tabla `events` y faltan columnas

-- Agrega columnas si no existen
ALTER TABLE events ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE events ADD COLUMN IF NOT EXISTS campaign_id TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS event_time TIMESTAMP DEFAULT NOW();
ALTER TABLE events ADD COLUMN IF NOT EXISTS ip TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS user_agent TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS country TEXT;

-- Lógica PL/pgSQL para agregar claves foráneas solo si no existen:
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE constraint_name = 'fk_events_participant' AND table_name = 'events'
  ) THEN
    ALTER TABLE events
      ADD CONSTRAINT fk_events_participant
      FOREIGN KEY (user_id) REFERENCES participants(id)
      ON DELETE SET NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE constraint_name = 'fk_events_campaign'
      AND table_name = 'events'
  ) THEN
    ALTER TABLE events
      ADD CONSTRAINT fk_events_campaign
      FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
      ON DELETE SET NULL;
  END IF;
END $$;

-- Indices
CREATE INDEX IF NOT EXISTS idx_events_user_id ON events(user_id);
CREATE INDEX IF NOT EXISTS idx_events_campaign_id ON events(campaign_id);
CREATE INDEX IF NOT EXISTS idx_events_event_type ON events(event_type);
CREATE INDEX IF NOT EXISTS idx_events_event_time ON events(event_time);
