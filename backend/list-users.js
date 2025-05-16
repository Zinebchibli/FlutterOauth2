/**
 * Script pour lister tous les utilisateurs dans la base de données
 */
require('dotenv').config();
const sequelize = require('./config/database');
const User = require('./models/User');

async function listUsers() {
  try {
    console.log('🔍 Recherche des utilisateurs dans la base de données...');
    
    // Se connecter à la base de données
    await sequelize.authenticate();
    console.log('✅ Connexion à PostgreSQL établie avec succès.');
    
    // Récupérer tous les utilisateurs
    const users = await User.findAll({
      attributes: ['id', 'username', 'name', 'createdAt']
    });
    
    console.log('==== LISTE DES UTILISATEURS ====');
    if (users.length === 0) {
      console.log('❌ Aucun utilisateur trouvé dans la base de données.');
    } else {
      users.forEach(user => {
        console.log(`ID: ${user.id} | Username: ${user.username} | Nom: ${user.name} | Création: ${user.createdAt}`);
      });
      console.log(`Total: ${users.length} utilisateur(s)`);
    }
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Erreur lors de la récupération des utilisateurs:', error);
    process.exit(1);
  }
}

listUsers();
