/**
 * Script de configuration initiale de la base de données PostgreSQL
 * pour l'application Flutter OAuth2 Login
 */
require('dotenv').config();
const { Client } = require('pg');
const sequelize = require('./config/database');
const User = require('./models/User');
const OAuthToken = require('./models/OAuthToken');

async function setupDatabase() {
  try {
    console.log('🔧 Configuration de la base de données PostgreSQL...');
    
    // Test de la connexion à PostgreSQL
    const client = new Client({
      user: process.env.DB_USER,
      host: process.env.DB_HOST,
      password: process.env.DB_PASS,
      port: process.env.DB_PORT || 5432,
    });

    await client.connect();
    console.log('✅ Connexion à PostgreSQL établie avec succès.');
    
    // Vérifier si la base de données existe, sinon la créer
    try {
      const dbExists = await client.query(`
        SELECT 1 FROM pg_database WHERE datname = '${process.env.DB_NAME}'
      `);
      
      if (dbExists.rows.length === 0) {
        console.log(`🏗️ Création de la base de données '${process.env.DB_NAME}'...`);
        await client.query(`CREATE DATABASE ${process.env.DB_NAME}`);
        console.log(`✅ Base de données '${process.env.DB_NAME}' créée avec succès.`);
      } else {
        console.log(`ℹ️ La base de données '${process.env.DB_NAME}' existe déjà.`);
      }
    } catch (dbError) {
      console.error('❌ Erreur lors de la vérification/création de la base de données:', dbError);
    } finally {
      await client.end();
    }
    
    // Configuration des modèles Sequelize et synchronisation avec la base de données
    User.hasMany(OAuthToken);
    OAuthToken.belongsTo(User, { foreignKey: 'userId' });
    
    await sequelize.sync({ force: true }); // ⚠️ 'force: true' va supprimer les tables existantes
    console.log('✅ Tables créées avec succès dans la base de données.');
    
    // Création d'un utilisateur de test
    const testUser = await User.create({
      username: 'test@example.com',
      password: 'password123',
      name: 'Utilisateur Test'
    });
    
    console.log(`✅ Utilisateur de test créé: ${testUser.username}`);
    console.log('🎉 Configuration de la base de données terminée avec succès!');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Erreur lors de la configuration de la base de données:', error);
    process.exit(1);
  }
}

setupDatabase();
