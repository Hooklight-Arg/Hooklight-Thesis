-- Indices orientados a consultas del dashboard ejecutivo (v24)
-- Seguro para re-ejecucion.

-- Eventos: filtros por tiempo + tipo + campaña + usuario
CREATE INDEX IF NOT EXISTS idx_events_time_type_campaign_user
  ON events (event_time, event_type, campaign_id, user_id);

-- Eventos: acceso frecuente por campaña y tiempo
CREATE INDEX IF NOT EXISTS idx_events_campaign_type_time
  ON events (campaign_id, event_type, event_time);

-- Eventos: acceso frecuente por usuario y tiempo
CREATE INDEX IF NOT EXISTS idx_events_user_time
  ON events (user_id, event_time);

-- Eventos: pais normalizado para distribuciones
CREATE INDEX IF NOT EXISTS idx_events_country_norm
  ON events ((COALESCE(NULLIF(TRIM(country), ''), 'N/A')));

-- Participantes: segmentaciones geograficas
CREATE INDEX IF NOT EXISTS idx_participants_province_department
  ON participants (province, department);

-- Participantes: joins + filtros de consentimiento
CREATE INDEX IF NOT EXISTS idx_participants_id_consent
  ON participants (id, consent);

-- Campañas: hitos y estado para anotaciones/contadores
CREATE INDEX IF NOT EXISTS idx_campaigns_active_start_end
  ON campaigns (is_active, start_date, end_date);
