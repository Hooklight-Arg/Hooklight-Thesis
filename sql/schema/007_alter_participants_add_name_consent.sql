-- Agrega campos para panel de consentimiento
ALTER TABLE participants
ADD COLUMN IF NOT EXISTS name TEXT,
ADD COLUMN IF NOT EXISTS consent BOOLEAN DEFAULT FALSE;
