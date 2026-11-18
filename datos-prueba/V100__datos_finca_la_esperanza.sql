-- HatoControl · datos de prueba (los mismos de los mockups de la Fase 5).
-- Solo para desarrollo y presentación. Contraseña de todos los usuarios de prueba: Esperanza26
-- La leche usa fechas relativas a hoy (hora de Colombia) para que el promedio de la semana siempre tenga datos.

INSERT INTO fincas (nombre, fecha_registro) VALUES
    ('La Esperanza', DATE '2026-01-15'),
    ('Los Rosales',  DATE '2026-03-02');

INSERT INTO usuarios (finca_id, nombre, correo, hash_contrasena, rol, activo)
SELECT f.id, u.nombre, u.correo, '$2b$10$BtzqhWTdPgZ01bOQTB5T5uLKSuujwKNjmnY04fl3WHUb1TNVMnkE6', u.rol, u.activo
FROM (VALUES
    ('La Esperanza', 'Jaider',         'jaider@laesperanza.example', 'GANADERO',      TRUE),
    ('La Esperanza', 'Camila Rosero',  'camila@laesperanza.example', 'ADMINISTRADOR', TRUE),
    ('La Esperanza', 'Andrés Muñoz',   'andres@laesperanza.example', 'ADMINISTRADOR', TRUE),
    ('Los Rosales',  'Marta Díaz',     'marta@losrosales.example',   'GANADERO',      TRUE)
) AS u (finca, nombre, correo, rol, activo)
JOIN fincas f ON f.nombre = u.finca;

-- Animales sin parto registrado en la finca
INSERT INTO animales (finca_id, codigo_arete, nombre, sexo, fecha_nacimiento, proposito)
SELECT f.id, a.arete, a.nombre, a.sexo, a.nacimiento, a.proposito
FROM (VALUES
    ('La Esperanza', 'CO-0105', 'Margarita', 'HEMBRA', DATE '2019-08-21', 'LECHE'),
    ('La Esperanza', 'CO-0117', 'Estrella',  'HEMBRA', DATE '2020-02-14', 'LECHE'),
    ('La Esperanza', 'CO-0142', 'Lucero',    'HEMBRA', DATE '2021-03-12', 'LECHE'),
    ('La Esperanza', 'CO-0163', 'Rayo',      'MACHO',  DATE '2022-06-30', 'ENGORDE'),
    ('La Esperanza', 'CO-0174', 'Mora',      'HEMBRA', DATE '2022-11-03', 'LECHE'),
    ('La Esperanza', 'CO-0201', 'Tormenta',  'MACHO',  DATE '2023-09-05', 'PADRON'),
    ('La Esperanza', 'CO-0212', 'Trueno',    'MACHO',  DATE '2024-01-19', 'ENGORDE'),
    ('La Esperanza', 'CO-0240', 'Paloma',    'HEMBRA', DATE '2025-04-02', 'ENGORDE'),
    ('La Esperanza', 'CO-0249', 'Nube',      'HEMBRA', DATE '2025-07-11', 'ENGORDE'),
    ('La Esperanza', 'CO-0256', NULL,        'MACHO',  NULL,              'ENGORDE'),
    ('Los Rosales',  'RS-0001', 'Perla',     'HEMBRA', DATE '2022-03-01', 'LECHE')
) AS a (finca, arete, nombre, sexo, nacimiento, proposito)
JOIN fincas f ON f.nombre = a.finca;

-- Partos (madre por arete dentro de La Esperanza)
INSERT INTO partos (madre_id, fecha)
SELECT an.id, p.fecha
FROM (VALUES
    ('CO-0142', DATE '2023-05-10'),
    ('CO-0142', DATE '2025-02-18'),
    ('CO-0105', DATE '2026-06-15')
) AS p (madre, fecha)
JOIN animales an ON an.codigo_arete = p.madre
JOIN fincas f ON f.id = an.finca_id AND f.nombre = 'La Esperanza';

-- Crías nacidas en la finca: Canela y Tizón, hijos de Lucero
INSERT INTO animales (finca_id, codigo_arete, nombre, sexo, fecha_nacimiento, proposito, parto_id)
SELECT f.id, c.arete, c.nombre, c.sexo, c.nacimiento, c.proposito, pa.id
FROM (VALUES
    ('CO-0188', 'Canela', 'HEMBRA', DATE '2023-05-10', 'LECHE'),
    ('CO-0231', 'Tizón',  'MACHO',  DATE '2025-02-18', 'ENGORDE')
) AS c (arete, nombre, sexo, nacimiento, proposito)
JOIN fincas f ON f.nombre = 'La Esperanza'
JOIN animales madre ON madre.finca_id = f.id AND madre.codigo_arete = 'CO-0142'
JOIN partos pa ON pa.madre_id = madre.id AND pa.fecha = c.nacimiento;

-- Parto de Canela (sin crías registradas)
INSERT INTO partos (madre_id, fecha)
SELECT an.id, DATE '2026-09-10'
FROM animales an JOIN fincas f ON f.id = an.finca_id
WHERE f.nombre = 'La Esperanza' AND an.codigo_arete = 'CO-0188';

-- Historial sanitario y actividades programadas
INSERT INTO registros_sanitarios (animal_id, tipo, descripcion, fecha_programada, fecha_realizacion, estado, observaciones)
SELECT an.id, s.tipo, s.descripcion, s.programada, s.realizada, s.estado, s.observaciones
FROM (VALUES
    ('CO-0142', 'VACUNA',      'Aftosa',                NULL::date,        DATE '2026-10-02', 'REALIZADA',  'Ciclo II'),
    ('CO-0142', 'ENFERMEDAD',  'Mastitis leve',         NULL,              DATE '2026-08-15', 'REALIZADA',  'Tratada con antibiótico'),
    ('CO-0142', 'VACUNA',      'Brucelosis',            DATE '2026-11-20', NULL,              'PROGRAMADA', 'Dosis única'),
    ('CO-0231', 'VACUNA',      'Aftosa',                NULL,              DATE '2026-10-02', 'REALIZADA',  'Ciclo II'),
    ('CO-0231', 'VACUNA',      'Carbón sintomático',    NULL,              DATE '2026-04-10', 'REALIZADA',  NULL),
    ('CO-0188', 'VACUNA',      'Aftosa',                DATE '2026-11-08', NULL,              'PROGRAMADA', NULL),
    ('CO-0240', 'TRATAMIENTO', 'Vitaminas',             DATE '2026-11-10', NULL,              'PROGRAMADA', NULL),
    ('CO-0201', 'TRATAMIENTO', 'Desparasitación',       DATE '2026-11-25', NULL,              'PROGRAMADA', 'Ivermectina'),
    ('CO-0201', 'VACUNA',      'Aftosa',                NULL,              DATE '2026-10-02', 'REALIZADA',  'Ciclo II'),
    ('CO-0105', 'TRATAMIENTO', 'Desparasitación',       NULL,              DATE '2026-09-20', 'REALIZADA',  NULL),
    ('CO-0163', 'VACUNA',      'Aftosa',                NULL,              DATE '2026-10-02', 'REALIZADA',  'Ciclo II')
) AS s (arete, tipo, descripcion, programada, realizada, estado, observaciones)
JOIN animales an ON an.codigo_arete = s.arete
JOIN fincas f ON f.id = an.finca_id AND f.nombre = 'La Esperanza';

-- Pesos
INSERT INTO registros_peso (animal_id, peso_kg, fecha_medicion)
SELECT an.id, p.kg, p.fecha
FROM (VALUES
    ('CO-0142', 418.0, DATE '2026-02-10'),
    ('CO-0142', 425.0, DATE '2026-05-12'),
    ('CO-0142', 430.0, DATE '2026-08-11'),
    ('CO-0142', 432.0, DATE '2026-11-10'),
    ('CO-0201', 505.0, DATE '2026-10-20'),
    ('CO-0231', 238.0, DATE '2026-05-14'),
    ('CO-0231', 262.0, DATE '2026-08-14'),
    ('CO-0231', 289.0, DATE '2026-10-14'),
    ('CO-0231', 286.0, DATE '2026-11-14'),
    ('CO-0240', 251.0, DATE '2026-11-05'),
    ('CO-0163', 398.5, DATE '2026-10-30'),
    ('CO-0212', 341.0, DATE '2026-10-30')
) AS p (arete, kg, fecha)
JOIN animales an ON an.codigo_arete = p.arete
JOIN fincas f ON f.id = an.finca_id AND f.nombre = 'La Esperanza';

-- Leche: Lucero todos los días de los últimos 60; Margarita los últimos 30;
-- Canela un día sí y otro no desde su parto (los días sin registro no cuentan en el promedio).
INSERT INTO registros_leche (animal_id, parto_id, fecha, litros)
SELECT an.id,
       (SELECT pa.id FROM partos pa WHERE pa.madre_id = an.id ORDER BY pa.fecha DESC LIMIT 1),
       d::date,
       CASE an.codigo_arete
           WHEN 'CO-0142' THEN 19 + (EXTRACT(DOY FROM d)::int % 5)
           WHEN 'CO-0105' THEN 16 + (EXTRACT(DOY FROM d)::int % 4)
           ELSE 18 + (EXTRACT(DOY FROM d)::int % 5)
       END
FROM animales an
JOIN fincas f ON f.id = an.finca_id AND f.nombre = 'La Esperanza'
CROSS JOIN LATERAL generate_series(
    (now() AT TIME ZONE 'America/Bogota')::date - CASE an.codigo_arete WHEN 'CO-0142' THEN 60 ELSE 30 END,
    (now() AT TIME ZONE 'America/Bogota')::date - 1,
    CASE an.codigo_arete WHEN 'CO-0188' THEN INTERVAL '2 days' ELSE INTERVAL '1 day' END) AS d
WHERE an.codigo_arete IN ('CO-0142', 'CO-0105', 'CO-0188');
