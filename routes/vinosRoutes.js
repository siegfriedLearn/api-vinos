const express = require('express');
const router = express.Router();
const vinosController = require('../controllers/vinosController');

// 1. Obtener promedio de puntuación por país
router.get('/pais/:pais', vinosController.getPromedioPais);

// 2. Obtener vinos por precio mínimo
router.get('/precio/:precio', vinosController.getVinosPorPrecio);

// 3. Obtener vinos por puntuación mínima
router.get('/puntuacion/:puntuacion', vinosController.getVinosPorPuntuacion);

module.exports = router;