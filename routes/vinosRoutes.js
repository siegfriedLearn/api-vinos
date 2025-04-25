const express = require('express');
const router = express.Router();
const vinosController = require('../controllers/vinosController');

// 1. Obtener promedio de puntuación por país
router.get('/pais/:pais', vinosController.getPromedioPais);

// 2. Obtener vinos por precio mínimo
router.get('/precio/:precio', vinosController.getVinosPorPrecio);

// 3. Obtener vinos por puntuación mínima
router.get('/puntuacion/:puntuacion', vinosController.getVinosPorPuntuacion);

// 4. Obtener vinos por tipo
router.get('/tipo/:tipo', vinosController.getVinosPorTipo);

// 5. Obtener vinos por cepa
router.get('/cepa/:cepa', vinosController.getVinosPorCepa);

module.exports = router;