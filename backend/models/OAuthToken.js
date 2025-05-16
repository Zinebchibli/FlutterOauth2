const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

// Modèle pour les tokens OAuth2
const OAuthToken = sequelize.define('OAuthToken', {
  accessToken: {
    type: DataTypes.STRING,
    allowNull: false
  },
  refreshToken: {
    type: DataTypes.STRING,
    allowNull: false
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  expiresAt: {
    type: DataTypes.DATE,
    allowNull: false
  }
});

module.exports = OAuthToken;
