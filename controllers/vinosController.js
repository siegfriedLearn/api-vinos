const pool = require('../database');

const vinosController = {
  // Endpoint 1: Promedio de puntuación por país
  getPromedioPais: async (req, res) => {
    try {
      const { pais } = req.params;
      
      const query = `
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
          p.nombre = $1
        GROUP BY 
          p.nombre
      `;
      
      const result = await pool.query(query, [pais]);
      
      if (result.rows.length === 0) {
        return res.status(404).json({ message: 'País no encontrado o sin vinos registrados' });
      }
      
      const data = result.rows[0];
      let calidad;
      
      if (data.promedio_puntuacion >= 9) calidad = "Excelente - Vinos de clase mundial";
      else if (data.promedio_puntuacion >= 8) calidad = "Muy bueno - Vinos de alta gama";
      else if (data.promedio_puntuacion >= 7) calidad = "Bueno - Vinos de calidad superior";
      else if (data.promedio_puntuacion >= 6) calidad = "Aceptable - Vinos decentes";
      else calidad = "Regular - Vinos básicos";
      
      res.json({
        pais: data.pais,
        promedio_puntuacion: parseFloat(data.promedio_puntuacion).toFixed(2),
        maxima_puntuacion: data.maxima_puntuacion,
        cantidad_vinos: data.cantidad_vinos,
        calidad_pais: calidad
      });
      
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al obtener datos del país' });
    }
  },

  // Endpoint 2: Vinos por precio mínimo
  getVinosPorPrecio: async (req, res) => {
    try {
      const { precio } = req.params;
      
      const query = `
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
          pr.precio >= $1
        ORDER BY 
          pr.precio DESC
      `;
      
      const result = await pool.query(query, [precio]);
      
      res.json({
        cantidad: result.rowCount,
        vinos: result.rows
      });
      
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al obtener vinos por precio' });
    }
  },

  // Endpoint 3: Vinos por puntuación mínima
  getVinosPorPuntuacion: async (req, res) => {
    try {
      const { puntuacion } = req.params;
      
      const query = `
        SELECT 
          v.vino_id,
          v.nombre AS vino,
          b.nombre AS bodega,
          p.nombre AS pais,
          ve.puntuacion,
          ve.experto_nombre,
          ve.fecha_valoracion,
          tv.nombre AS tipo_vino
        FROM 
          vinos.vinos v
        JOIN 
          vinos.bodegas b ON v.bodega_id = b.bodega_id
        JOIN 
          vinos.paises p ON b.pais_id = p.pais_id
        JOIN 
          vinos.tipos_vino tv ON v.tipo_id = tv.tipo_id
        JOIN 
          vinos.valoraciones_expertos ve ON v.vino_id = ve.vino_id
        WHERE 
          ve.puntuacion >= $1
        ORDER BY 
          ve.puntuacion DESC
      `;
      
      const result = await pool.query(query, [puntuacion]);
      
      res.json({
        cantidad: result.rowCount,
        vinos: result.rows
      });
      
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al obtener vinos por puntuación' });
    }
  },

  // Endpoint 4: Vinos por tipo
  getVinosPorTipo: async (req, res) => {
    try {
      const { tipo } = req.params;
      
      const query = `
        SELECT 
          v.vino_id,
          v.nombre AS vino,
          b.nombre AS bodega,
          p.nombre AS pais,
          v.anio_produccion,
          v.porcentaje_alcohol,
          STRING_AGG(DISTINCT c.nombre, ', ') AS cepas
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
        WHERE 
          LOWER(tv.nombre) = LOWER($1)
        GROUP BY 
          v.vino_id, v.nombre, b.nombre, p.nombre, v.anio_produccion, v.porcentaje_alcohol
        ORDER BY 
          v.nombre
      `;
      
      const result = await pool.query(query, [tipo]);
      
      res.json({
        tipo: tipo,
        cantidad: result.rowCount,
        vinos: result.rows
      });
      
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al obtener vinos por tipo' });
    }
  },

// Endpoint 5: Vinos por .cepa
  getVinosPorCepa: async (req, res) => {
    try {
      const { cepa } = req.params;
      
      const query = `
        SELECT 
          v.vino_id,
          v.nombre AS vino,
          b.nombre AS bodega,
          p.nombre AS pais,
          v.anio_produccion,
          v.porcentaje_alcohol,
          tv.nombre AS tipo_vino,
          comp.porcentaje AS porcentaje_cepa
        FROM 
          vinos.vinos v
        JOIN 
          vinos.bodegas b ON v.bodega_id = b.bodega_id
        JOIN 
          vinos.paises p ON b.pais_id = p.pais_id
        JOIN 
          vinos.tipos_vino tv ON v.tipo_id = tv.tipo_id
        JOIN 
          vinos.composicion comp ON v.vino_id = comp.vino_id
        JOIN 
          vinos.cepas c ON comp.cepa_id = c.cepa_id
        WHERE 
          LOWER(c.nombre) = LOWER($1)
        ORDER BY 
          comp.porcentaje DESC, v.nombre
      `;
      
      const result = await pool.query(query, [cepa]);
      
      res.json({
        cepa: cepa,
        cantidad: result.rowCount,
        vinos: result.rows
      });
      
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al obtener vinos por cepa' });
    }
  }

};

module.exports = vinosController;