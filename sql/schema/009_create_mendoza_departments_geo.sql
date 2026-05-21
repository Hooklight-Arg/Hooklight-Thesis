-- Tabla de centroides (lat/lon) por departamento de Mendoza
-- Usada por Grafana Geomap (Location mode: Coordinates)

CREATE TABLE IF NOT EXISTS mendoza_departments_geo (
  department TEXT PRIMARY KEY,
  lat DOUBLE PRECISION NOT NULL,
  lon DOUBLE PRECISION NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_mendoza_departments_geo_department
  ON mendoza_departments_geo (department);
