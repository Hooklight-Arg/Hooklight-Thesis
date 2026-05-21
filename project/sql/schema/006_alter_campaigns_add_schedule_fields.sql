-- Agrega campos para paneles de campañas (seguro para re-ejecución)

ALTER TABLE campaigns
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE,
ADD COLUMN IF NOT EXISTS start_date TIMESTAMPTZ NULL,
ADD COLUMN IF NOT EXISTS end_date TIMESTAMPTZ NULL;

UPDATE campaigns
SET is_active = TRUE
WHERE is_active IS NULL;
