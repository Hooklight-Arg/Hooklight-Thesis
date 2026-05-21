-- Agrega ubicación declarada del participante (provincia/departamento)
-- Seguro para re-ejecución

ALTER TABLE participants
ADD COLUMN IF NOT EXISTS province TEXT,
ADD COLUMN IF NOT EXISTS department TEXT;

-- Índices para acelerar filtros por ubicación
CREATE INDEX IF NOT EXISTS idx_participants_province ON participants(province);
CREATE INDEX IF NOT EXISTS idx_participants_department ON participants(department);
