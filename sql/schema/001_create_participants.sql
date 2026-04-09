-- Crea la tabla de participantes/usuarios de campaña
-- Esta tabla representa a los usuarios alcanzados por la simulación

CREATE TABLE IF NOT EXISTS participants (
  id UUID PRIMARY KEY, -- UUID: identificador no secuencial, más seguro para tracking
  name TEXT,
  email TEXT NOT NULL UNIQUE,
  consent BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW() -- Fecha de creación del registro
);
