-- Carga inicial de departamentos de Mendoza con coordenadas (centroides aproximados)

INSERT INTO mendoza_departments_geo (department, lat, lon) VALUES
('Capital',         -32.8895, -68.8458),
('Godoy Cruz',      -32.9290, -68.8272),
('Guaymallen',      -32.8850, -68.7370),
('Las Heras',       -32.8520, -68.8280),
('Lujan de Cuyo',   -33.0393, -68.8802),
('Maipu',           -32.9767, -68.7808),
('San Martin',      -33.0810, -68.4681),
('Junin',           -33.1463, -68.4784),
('Rivadavia',       -33.1900, -68.4670),
('Santa Rosa',      -33.2547, -68.1480),
('La Paz',          -33.4600, -67.5600),
('Lavalle',         -32.7137, -68.3159),
('Tunuyan',         -33.5763, -69.0165),
('Tupungato',       -33.3714, -69.1479),
('San Carlos',      -33.7710, -69.0417),
('San Rafael',      -34.6177, -68.3301),
('General Alvear',  -34.9766, -67.6954),
('Malargue',        -35.4752, -69.5843)
ON CONFLICT (department) DO UPDATE
SET
  lat = EXCLUDED.lat,
  lon = EXCLUDED.lon;
