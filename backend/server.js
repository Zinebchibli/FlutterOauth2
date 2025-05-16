const express = require('express');
const cors = require('cors');
require('dotenv').config();
const sequelize = require('./config/database');
const User = require('./models/User');
const OAuthToken = require('./models/OAuthToken');

// Initialize Express
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
  origin: '*', // Autorise toutes les origines pour le débogage
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Middleware de logging pour le débogage
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Association entre les modèles
User.hasMany(OAuthToken);
OAuthToken.belongsTo(User, { foreignKey: 'userId' });

// Routes
app.use('/oauth', require('./routes/oauth'));
app.use('/', require('./routes/api'));

// Route par défaut
app.get('/', (req, res) => {
  res.send('API OAuth2 avec PostgreSQL fonctionnelle!');
});

// Synchroniser la base de données et démarrer le serveur
sequelize
  .sync({ force: false }) // Ne pas utiliser { force: true } en production!
  .then(() => {
    console.log('📊 Base de données PostgreSQL synchronisée');
    app.listen(PORT, () => {
      console.log(`🚀 Serveur démarré sur http://localhost:${PORT}`);
    });
  })
  .catch(err => {
    console.error('❌ Erreur lors de la synchronisation de la base de données:', err);
  });

module.exports = app;
