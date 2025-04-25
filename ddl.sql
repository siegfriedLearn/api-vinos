-- Tabla de países
CREATE TABLE paises (
    pais_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    region_vinicola VARCHAR(100),
    clima VARCHAR(50),
    descripcion TEXT
);

-- Tabla de bodegas
CREATE TABLE bodegas (
    bodega_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais_id INTEGER REFERENCES paises(pais_id),
    fundacion INTEGER,
    historia TEXT,
    tecnicas_produccion TEXT
);

-- Tabla de cepas (uvas)
CREATE TABLE cepas (
    cepa_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    caracteristicas TEXT,
    tipo_cepa VARCHAR(50) CHECK (tipo_cepa IN ('Tinta', 'Blanca', 'Rosada'))
);

-- Tabla de tipos de vino
CREATE TABLE tipos_vino (
    tipo_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla de vinos
CREATE TABLE vinos (
    vino_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    bodega_id INTEGER REFERENCES bodegas(bodega_id),
    tipo_id INTEGER REFERENCES tipos_vino(tipo_id),
    anio_produccion INTEGER,
    porcentaje_alcohol DECIMAL(4,2),
    tiempo_guardado INTEGER, -- en meses
    descripcion TEXT,
    puntuacion INTEGER,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de composición (cepas que componen cada vino)
CREATE TABLE composicion (
    composicion_id SERIAL PRIMARY KEY,
    vino_id INTEGER REFERENCES vinos(vino_id),
    cepa_id INTEGER REFERENCES cepas(cepa_id),
    porcentaje DECIMAL(5,2),
    UNIQUE(vino_id, cepa_id)
);

-- Tabla de características organolépticas
CREATE TABLE caracteristicas (
    caracteristica_id SERIAL PRIMARY KEY,
    vino_id INTEGER REFERENCES vinos(vino_id),
    color VARCHAR(50),
    aroma VARCHAR(100),
    sabor VARCHAR(100),
    cuerpo VARCHAR(50),
    taninos VARCHAR(50),
    acidez VARCHAR(50),
    persistencia VARCHAR(50)
);

-- Tabla de premios y reconocimientos
CREATE TABLE premios (
    premio_id SERIAL PRIMARY KEY,
    vino_id INTEGER REFERENCES vinos(vino_id),
    nombre_premio VARCHAR(100),
    anio INTEGER,
    puntuacion DECIMAL(3,1),
    descripcion TEXT
);

-- Tabla de valoraciones de expertos
CREATE TABLE valoraciones_expertos (
    valoracion_id SERIAL PRIMARY KEY,
    vino_id INTEGER REFERENCES vinos(vino_id),
    experto_nombre VARCHAR(100),
    fecha_valoracion DATE,
    puntuacion DECIMAL(3,1) CHECK (puntuacion BETWEEN 0 AND 100),
    comentarios TEXT
);

-- Tabla de precios
CREATE TABLE precios (
    precio_id SERIAL PRIMARY KEY,
    vino_id INTEGER REFERENCES vinos(vino_id),
    precio DECIMAL(10,2),
    moneda VARCHAR(3),
    anio INTEGER,
    fuente VARCHAR(100)
);

-- Tabla de maridajes
CREATE TABLE maridajes (
    maridaje_id SERIAL PRIMARY KEY,
    vino_id INTEGER REFERENCES vinos(vino_id),
    alimento VARCHAR(100),
    descripcion TEXT
);

-- Tabla de condiciones de guarda recomendadas
CREATE TABLE condiciones_guarda (
    condicion_id SERIAL PRIMARY KEY,
    vino_id INTEGER REFERENCES vinos(vino_id),
    temperatura_optima DECIMAL(4,2), -- en °C
    humedad_optima DECIMAL(4,2), -- en %
    tiempo_guardado_optimo INTEGER -- en meses
);

-- Tabla de producción
CREATE TABLE produccion (
    produccion_id SERIAL PRIMARY KEY,
    vino_id INTEGER REFERENCES vinos(vino_id),
    cantidad_botellas INTEGER,
    anio INTEGER,
    metodo_elaboracion TEXT
);



-- INSERT
-- 1. Insertar países
INSERT INTO paises (nombre, region_vinicola, clima) VALUES
('Francia', 'Borgoña', 'Templado continental'),
('Francia', 'Burdeos', 'Oceánico'),
('Francia', 'Champaña', 'Fresco continental'),
('Italia', 'Toscana', 'Mediterráneo'),
('Italia', 'Piamonte', 'Continental moderado'),
('España', 'Rioja', 'Continental mediterráneo'),
('España', 'Ribera del Duero', 'Extremo continental'),
('Portugal', 'Douro', 'Mediterráneo con influencia atlántica'),
('Argentina', 'Mendoza', 'Desértico continental'),
('Chile', 'Valle Central', 'Mediterráneo'),
('Estados Unidos', 'Napa Valley', 'Mediterráneo'),
('Australia', 'Barossa Valley', 'Cálido mediterráneo'),
('Alemania', 'Mosela', 'Fresco continental'),
('Sudáfrica', 'Stellenbosch', 'Mediterráneo');

-- 2. Insertar bodegas
INSERT INTO bodegas (nombre, pais_id, fundacion) VALUES
-- Francia
('Domaine de la Romanée-Conti', 1, 1869),
('Château Margaux', 2, 1590),
('Dom Pérignon', 3, 1823),
-- Italia
('Antinori', 4, 1385),
('Gaja', 5, 1859),
-- España
('Vega Sicilia', 6, 1864),
('Marqués de Riscal', 6, 1858),
-- Portugal
('Quinta do Noval', 8, 1715),
-- Argentina
('Catena Zapata', 9, 1902),
-- Chile
('Concha y Toro', 10, 1883),
-- Estados Unidos
('Opus One', 11, 1979),
('Screaming Eagle', 11, 1986),
-- Australia
('Penfolds', 12, 1844),
-- Alemania
('Dr. Loosen', 13, 1800),
-- Sudáfrica
('Kanonkop', 14, 1910);

-- 3. Insertar cepas
INSERT INTO cepas (nombre, descripcion, tipo_cepa) VALUES
-- Tintas
('Pinot Noir', 'Uva elegante y compleja', 'Tinta'),
('Cabernet Sauvignon', 'Uva estructurada con taninos firmes', 'Tinta'),
('Merlot', 'Uva suave y redonda', 'Tinta'),
('Syrah', 'Uva potente con notas especiadas', 'Tinta'),
('Malbec', 'Uva intensa con notas frutales', 'Tinta'),
('Tempranillo', 'Uva principal de Rioja', 'Tinta'),
('Sangiovese', 'Uva base del Chianti', 'Tinta'),
('Nebbiolo', 'Uva noble del Piamonte', 'Tinta'),
('Touriga Nacional', 'Principal uva del Oporto', 'Tinta'),
('Grenache', 'Uva mediterránea', 'Tinta'),
-- Blancas
('Chardonnay', 'Uva versátil para blancos', 'Blanca'),
('Sauvignon Blanc', 'Uva fresca y herbácea', 'Blanca'),
('Riesling', 'Uva aromática y mineral', 'Blanca'),
('Chenin Blanc', 'Uva versátil sudafricana', 'Blanca'),
('Gewürztraminer', 'Uva aromática y especiada', 'Blanca'),
('Viognier', 'Uva floral y perfumada', 'Blanca');

-- 4. Insertar tipos de vino
INSERT INTO tipos_vino (nombre, descripcion) VALUES
('Tinto', 'Vino elaborado con uvas tintas'),
('Blanco', 'Vino elaborado con uvas blancas'),
('Rosado', 'Vino de contacto breve con hollejos'),
('Espumoso', 'Vino con burbujas de carbono'),
('Dulce', 'Vino con azúcar residual'),
('Fortificado', 'Vino con alcohol añadido');

-- 5. Insertar vinos (más de 40 ejemplos reales)
INSERT INTO vinos (nombre, bodega_id, tipo_id, anio_produccion, porcentaje_alcohol, tiempo_guardado, descripcion, puntuacion) VALUES
-- Vinos franceses
('Romanée-Conti', 1, 1, 2015, 13.5, 120, 'El pinot noir más legendario del mundo', 8),
('La Tâche', 1, 1, 2016, 13.0, 108, 'Grand cru de Vosne-Romanée', 9),
('Château Margaux', 2, 1, 2010, 13.0, 96, 'Premier Grand Cru Classé de Margaux', 10),
('Dom Pérignon', 3, 4, 2008, 12.5, 144, 'Prestigioso champán vintage', 7),
('Petrus', 2, 1, 2012, 14.0, 84, 'Legendario merlot de Pomerol', 10),
-- Vinos italianos
('Tignanello', 4, 1, 2016, 13.5, 60, 'Super toscano pionero', 6),
('Barolo Sperss', 5, 1, 2013, 14.0, 72, 'Nebbiolo de Serralunga Alba', 9),
('Solaia', 4, 1, 2015, 14.0, 60, 'Cabernet sauvignon toscano', 7),
('Barbaresco', 5, 1, 2014, 13.5, 72, 'Nebbiolo elegante', 7),
('Amarone della Valpolicella', 4, 1, 2012, 15.5, 84, 'Vino de uvas pasificadas', 9),
-- Vinos españoles
('Unico', 6, 1, 2010, 14.0, 120, 'Gran reserva de Ribera del Duero', 8),
('Barón de Chirel', 7, 1, 2015, 14.0, 60, 'Tinto moderno de Rioja', 8),
('Pingus', 6, 1, 2016, 14.5, 96, 'Cult wine español', 9),
('Vega Sicilia Unico', 6, 1, 2009, 14.0, 108, 'Icono español', 9),
-- Vinos portugueses
('Nacional', 8, 1, 2011, 14.0, 96, 'Oporto vintage de parcela única', 6),
('Quinta do Noval Vintage', 8, 6, 2017, 20.0, 240, 'Oporto vintage tradicional', 7),
-- Vinos argentinos
('Catena Zapata Adrianna Vineyard', 9, 1, 2016, 13.5, 60, 'Malbec de altura', 8),
('Nicolás Catena Zapata', 9, 1, 2015, 14.0, 72, 'Blend bordelés mendocino', 8),
-- Vinos chilenos
('Almaviva', 10, 1, 2017, 14.0, 60, 'Joint venture con Rothschild', 7),
('Don Melchor', 10, 1, 2016, 14.0, 60, 'Cabernet sauvignon de Puente Alto', 9),
('Seña', 10, 1, 2015, 14.0, 72, 'Proyecto de Mondavi y Chadwick', 9),
-- Vinos estadounidenses
('Opus One', 11, 1, 2014, 14.5, 60, 'Blend de Napa Valley', 10),
('Screaming Eagle', 12, 1, 2013, 14.5, 84, 'Cult wine californiano', 4),
('Harlan Estate', 11, 1, 2012, 14.5, 96, 'Grand cru de Napa', 6),
('Ridge Monte Bello', 11, 1, 2015, 13.5, 120, 'Cabernet de Santa Cruz', 5),
-- Vinos australianos
('Grange', 13, 1, 2014, 14.5, 120, 'Icono australiano',4 ),
('Hill of Grace', 13, 1, 2013, 14.0, 108, 'Shiraz de viñas viejas', 5),
-- Vinos alemanes
('Erdener Prälat Riesling Auslese', 14, 2, 2017, 8.0, 60, 'Riesling dulce del Mosela',6),
('Wehlener Sonnenuhr Riesling GG', 14, 2, 2016, 12.5, 48, 'Riesling seco premium', 4),
-- Vinos sudafricanos
('Paul Sauer', 15, 1, 2015, 14.0, 72, 'Blend clásico sudafricano',8 ),
('Pinotage Reserve', 15, 1, 2016, 14.0, 60, 'Varietal emblemático', 9),
-- Vinos adicionales para completar los 40+
('Château Lafite Rothschild', 2, 1, 2009, 13.0, 120, 'Premier Grand Cru Classé de Pauillac',4),
('Château Mouton Rothschild', 2, 1, 2010, 13.5, 108, 'Premier Grand Cru Classé con etiquetas artísticas',3),
('Château d Yquem', 2, 5, 2011, 14.0, 180, 'Legendario vino dulce de Sauternes', 3),
('Krug Clos du Mesnil', 3, 4, 2002, 12.5, 216, 'Chardonnay de parcela única', 3),
('Masseto', 4, 1, 2013, 14.0, 96, 'Merlot toscano de culto', 6),
('Ornellaia', 4, 1, 2015, 14.0, 72, 'Super toscano bolgherese',9),
('Clos Erasmus', 7, 1, 2012, 15.0, 84, 'Priorat de garnacha y syrah', 7),
('Château Cheval Blanc', 2, 1, 2005, 13.5, 168, 'Legendario Saint-Émilion', 6),
('Penfolds Bin 707', 13, 1, 2014, 14.5, 96, 'Cabernet sauvignon australiano',6),
('Domaine Leroy Musigny', 1, 1, 2012, 13.0, 120, 'Pinot noir de Grand Cru',6),
('Château Latour', 2, 1, 2003, 13.0, 192, 'Premier Grand Cru Classé de Pauillac',6),
('Château Haut-Brion', 2, 1, 2009, 13.5, 132, 'Premier Grand Cru Classé de Pessac-Léognan',6),
('Domaine Leflaive Montrachet', 1, 2, 2014, 13.0, 84, 'Chardonnay legendario',6),
('Richebourg', 1, 1, 2011, 13.5, 120, 'Grand Cru de Vosne-Romanée',6);

-- 6. Insertar composición de los vinos
INSERT INTO composicion (vino_id, cepa_id, porcentaje) VALUES
-- Romanée-Conti
(1, 1, 100),
-- Château Margaux
(3, 2, 75), (3, 3, 20), (3, 6, 5),
-- Tignanello
(6, 7, 80), (6, 2, 15), (6, 3, 5),
-- Vega Sicilia Unico
(14, 6, 80), (14, 2, 10), (14, 3, 10),
-- Nicolás Catena Zapata
(18, 2, 80), (18, 5, 20),
-- Almaviva
(20, 2, 68), (20, 3, 22), (20, 6, 10),
-- Grange
(27, 4, 100),
-- Paul Sauer
(31, 2, 70), (31, 3, 20), (31, 4, 10);

-- 7. Insertar características organolépticas
INSERT INTO caracteristicas (vino_id, color, aroma, sabor, cuerpo, taninos, acidez, persistencia) VALUES
(1, 'Rojo rubí', 'Cereza, frambuesa, trufa', 'Elegante, complejo, mineral', 'Medio', 'Sedosos', 'Viva', 'Extremadamente larga'),
(3, 'Rojo granate', 'Cassís, violeta, cedro', 'Estructurado, elegante, especiado', 'Completo', 'Firmes', 'Fresca', 'Muy larga'),
(6, 'Rojo intenso', 'Cereza negra, tabaco, cuero', 'Potente, estructurado, equilibrado', 'Completo', 'Maduros', 'Fresca', 'Larga'),
(14, 'Rojo picota', 'Mora, regaliz, vainilla', 'Complejo, elegante, balsámico', 'Completo', 'Redondos', 'Equilibrada', 'Muy larga'),
(20, 'Rojo oscuro', 'Cassís, pimiento, chocolate', 'Potente, concentrado, especiado', 'Completo', 'Firmes', 'Fresca', 'Larga'),
(27, 'Rojo violáceo', 'Ciruela, pimienta, chocolate', 'Concentrado, potente, especiado', 'Completo', 'Maduros', 'Fresca', 'Muy larga');

-- 8. Insertar premios y reconocimientos
INSERT INTO premios (vino_id, nombre_premio, anio, puntuacion, descripcion) VALUES
(1, 'Wine Spectator Top 100', 2018, 99, 'Vino del año'),
(3, 'Decanter World Wine Awards', 2015, 98, 'Mejor vino de Burdeos'),
(6, 'James Suckling', 2019, 97, 'Super toscano excepcional'),
(14, 'Robert Parker Wine Advocate', 2012, 99, 'Perfecto'),
(20, 'Descorchados', 2020, 98, 'Mejor vino chileno'),
(27, 'Wine Advocate', 2016, 99, 'Icono australiano');

-- 9. Insertar valoraciones de expertos
INSERT INTO valoraciones_expertos (vino_id, experto_nombre, fecha_valoracion, puntuacion, comentarios) VALUES
(1, 'Robert Parker', '2018-05-15', 99, 'La perfección hecha vino'),
(3, 'Jancis Robinson', '2016-10-22', 19.5, 'Elegancia y potencia en equilibrio'),
(6, 'James Suckling', '2019-03-10', 97, 'Toscana en su máxima expresión'),
(14, 'Luis Gutiérrez', '2017-07-05', 99, 'Unico en todos los sentidos'),
(20, 'Patricio Tapia', '2020-01-18', 96, 'El mejor Almaviva hasta la fecha'),
(27, 'Joe Czerwinski', '2018-11-30', 98, 'Shiraz que desafía el tiempo');

-- 10. Insertar precios
INSERT INTO precios (vino_id, precio, moneda, anio, fuente) VALUES
(1, 15000, 'USD', 2023, 'Wine-Searcher'),
(3, 1200, 'USD', 2023, 'Wine-Searcher'),
(6, 350, 'USD', 2023, 'Wine-Searcher'),
(14, 800, 'USD', 2023, 'Wine-Searcher'),
(20, 250, 'USD', 2023, 'Wine-Searcher'),
(27, 850, 'AUD', 2023, 'Wine-Searcher'),
(2, 5000, 'USD', 2023, 'Wine-Searcher'),
(4, 300, 'USD', 2023, 'Wine-Searcher'),
(7, 400, 'USD', 2023, 'Wine-Searcher');

-- 11. Insertar maridajes
INSERT INTO maridajes (vino_id, alimento, descripcion) VALUES
(1, 'Pato a la naranja', 'La acidez y elegancia complementan la grasa del pato'),
(3, 'Cordero asado', 'Los taninos cortan la grasa y resaltan los sabores'),
(6, 'Bistecca alla Fiorentina', 'El poder del vino iguala la intensidad de la carne'),
(14, 'Cochinillo asado', 'La estructura del vino soporta la grasa del cerdo'),
(20, 'Costillas BBQ', 'Los taninos y fruta oscura complementan el ahumado');

-- 12. Insertar condiciones de guarda
INSERT INTO condiciones_guarda (vino_id, temperatura_optima, humedad_optima, tiempo_guardado_optimo) VALUES
(1, 13.0, 70, 240),
(3, 14.0, 75, 180),
(6, 16.0, 70, 120),
(14, 15.0, 72, 144),
(20, 16.0, 68, 96),
(27, 16.0, 70, 180);

-- 13. Insertar producción
INSERT INTO produccion (vino_id, cantidad_botellas, anio, metodo_elaboracion) VALUES
(1, 5000, 2015, 'Fermentación natural, crianza en barricas nuevas'),
(3, 15000, 2010, 'Selección manual, crianza 18 meses en barrica'),
(6, 25000, 2016, 'Maceración prolongada, crianza en barricas usadas'),
(14, 50000, 2009, 'Fermentación tradicional, crianza prolongada'),
(20, 80000, 2017, 'Maceration fría, fermentación en barricas'),
(27, 100000, 2014, 'Fermentación abierta, crianza en roble americano');


-- Vista para puntuaciones promedio


CREATE VIEW vinos.vw_puntuaciones_promedio AS
SELECT v.vino_id, v.nombre AS vino, b.nombre AS bodega, 
       AVG(ve.puntuacion) AS puntuacion_expertos,
       AVG(p.puntuacion) AS puntuacion_premios,
       COUNT(ve.valoracion_id) AS num_valoraciones,
       COUNT(p.premio_id) AS num_premios
FROM vinos.vinos v
LEFT JOIN vinos.valoraciones_expertos ve ON v.vino_id = ve.vino_id
LEFT JOIN vinos.premios p ON v.vino_id = p.vino_id
JOIN vinos.bodegas b ON v.bodega_id = b.bodega_id
GROUP BY v.vino_id, v.nombre, b.nombre;

-- Vista para relación precio-calidad
CREATE VIEW vinos.vw_relacion_precio_calidad AS
SELECT v.vino_id, v.nombre, 
       pr.precio, pr.moneda,
       vp.puntuacion_expertos,
       (vp.puntuacion_expertos / NULLIF(pr.precio, 0)) AS relacion_calidad_precio
FROM vinos.vinos v
JOIN vw_puntuaciones_promedio vp ON v.vino_id = vp.vino_id
JOIN vinos.precios pr ON v.vino_id = pr.vino_id
WHERE pr.anio = EXTRACT(YEAR FROM CURRENT_DATE);



SELECT 
    v.vino_id,
    v.nombre AS nombre_vino,
    b.nombre AS bodega,
    p.nombre AS pais,
    p.region_vinicola,
    v.anio_produccion,
    v.porcentaje_alcohol,
    tv.nombre AS tipo_vino,
    v.puntuacion as Puntuación,
    STRING_AGG(DISTINCT c.nombre, ', ') AS cepas,
    pr.precio,
    pr.moneda
FROM 
    vinos.vinos v
JOIN 
    vinos.bodegas b ON v.bodega_id = b.bodega_id
JOIN 
    vinos.paises p ON b.pais_id = p.pais_id
JOIN 
    vinos.tipos_vino tv ON v.tipo_id = tv.tipo_id
LEFT JOIN 
    vinos.composicion comp ON v.vino_id = comp.vino_id
LEFT JOIN 
    vinos.cepas c ON comp.cepa_id = c.cepa_id
LEFT JOIN 
    vinos.precios pr ON v.vino_id = pr.vino_id AND pr.anio = EXTRACT(YEAR FROM CURRENT_DATE)
WHERE p.nombre = 'Francia'
GROUP BY 
    v.vino_id, v.nombre, b.nombre, p.nombre, p.region_vinicola, 
    v.anio_produccion, v.porcentaje_alcohol, tv.nombre, pr.precio, pr.moneda
ORDER BY 
    p.nombre, v.nombre;


-- TRAER PROMEDIO DE PUNTUACIÓN
SELECT 
          p.nombre AS pais,
          AVG(v.puntuacion) AS promedio_puntuacion,
          MAX(v.puntuacion) AS maxima_puntuacion,
          COUNT(DISTINCT v.vino_id) AS cantidad_vinos
        FROM 
          vinos.paises p
        JOIN 
          vinos.bodegas b ON p.pais_id = b.pais_id
        JOIN 
          vinos.vinos v ON b.bodega_id = v.bodega_id
        WHERE 
          p.nombre = 'Francia'
        GROUP BY 
          p.nombre
          
          --TRAER PUNTUACIÓN POR PAÍS
   SELECT 
          p.nombre AS pais, v.puntuacion, v.vino_id
        FROM 
          vinos.paises p
        JOIN 
          vinos.bodegas b ON p.pais_id = b.pais_id
        JOIN 
          vinos.vinos v ON b.bodega_id = v.bodega_id
        WHERE 
          p.nombre = 'Francia'
          
          --TRAER VINOS POR PRECIO
          SELECT 
          v.vino_id,
          v.nombre AS vino,
          b.nombre AS bodega,
          p.nombre AS pais,
          pr.precio,
          pr.moneda,
          tv.nombre AS tipo_vino,
          v.anio_produccion
        FROM 
          vinos.vinos v
        JOIN 
          vinos.bodegas b ON v.bodega_id = b.bodega_id
        JOIN 
          vinos.paises p ON b.pais_id = p.pais_id
        JOIN 
          vinos.tipos_vino tv ON v.tipo_id = tv.tipo_id
        JOIN 
          vinos.precios pr ON v.vino_id = pr.vino_id
        WHERE 
          pr.precio >= 200
        ORDER BY 
          pr.precio DESC
 