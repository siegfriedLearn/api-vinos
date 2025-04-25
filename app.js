const express = require('express');
const cors = require('cors');
// const vinosRoutes = require('./routes/vinosRoutes');
const vinosRoutes = require('./routes/vinosRoutes.js');

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// Rutas
app.use('/api/vinos', vinosRoutes);

// Manejador de errores
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Algo salió mal!');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
});