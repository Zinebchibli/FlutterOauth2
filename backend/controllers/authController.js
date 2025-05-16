const jwt = require('jsonwebtoken');
const User = require('../models/User');
const OAuthToken = require('../models/OAuthToken');
const crypto = require('crypto');

// Fonctions utilitaires pour OAuth2
const generateTokens = async (userId) => {
  // Générer un access token (valide 1 heure)
  const accessToken = jwt.sign({ userId }, process.env.JWT_SECRET, { 
    expiresIn: '1h' 
  });
  
  // Générer un refresh token (valide 7 jours)
  const refreshToken = crypto.randomBytes(40).toString('hex');
  
  // Calculer la date d'expiration (7 jours)
  const expiresAt = new Date();
  expiresAt.setDate(expiresAt.getDate() + 7);
  
  // Enregistrer le token dans la base de données
  await OAuthToken.create({
    accessToken,
    refreshToken,
    userId,
    expiresAt
  });
  
  return { accessToken, refreshToken };
};

// Contrôleur d'authentification
const authController = {
    // Point d'entrée pour l'authentification OAuth2
  async oauthToken(req, res) {
    try {
      // Vérification de l'authentification basique avec client_id et client_secret
      const authHeader = req.headers.authorization;
      console.log('Headers de la requête:', req.headers);
      console.log('Corps de la requête:', req.body);
      
      if (!authHeader || !authHeader.startsWith('Basic ')) {
        console.log('❌ Erreur: Authentification basique manquante');
        return res.status(401).json({ error: 'Authentification basique requise' });
      }
      
      // Décoder les identifiants client
      const base64Credentials = authHeader.split(' ')[1];
      const credentials = Buffer.from(base64Credentials, 'base64').toString('ascii');
      const [clientId, clientSecret] = credentials.split(':');
      
      console.log(`🔑 Identifiants client reçus: ${clientId} / [SECRET MASQUÉ]`);
      console.log(`🔐 Identifiants attendus: ${process.env.CLIENT_ID} / [SECRET MASQUÉ]`);
      
      // Vérifier les identifiants client
      if (clientId !== process.env.CLIENT_ID || clientSecret !== process.env.CLIENT_SECRET) {
        console.log('❌ Erreur: Identifiants client incorrects');
        return res.status(401).json({ error: 'Identifiants client incorrects' });
      }
      
      const { grant_type } = req.body;
        // Grant type: password (authentification utilisateur)
      if (grant_type === 'password') {
        const { username, password } = req.body;
        console.log(`👤 Tentative de connexion pour l'utilisateur: ${username}`);
        
        // Vérifier que l'utilisateur existe
        const user = await User.findOne({ where: { username } });
        if (!user) {
          console.log(`❌ Utilisateur non trouvé: ${username}`);
          return res.status(401).json({ error: 'Identifiants incorrects' });
        }
        
        // Vérifier le mot de passe
        const isMatch = await user.validatePassword(password);
        if (!isMatch) {
          console.log(`❌ Mot de passe incorrect pour: ${username}`);
          return res.status(401).json({ error: 'Identifiants incorrects' });
        }
        
        console.log(`✅ Authentification réussie pour: ${username}`);
        
        // Générer des tokens
        const { accessToken, refreshToken } = await generateTokens(user.id);
        
        // Envoyer la réponse
        return res.json({
          access_token: accessToken,
          token_type: 'Bearer',
          expires_in: 3600, // 1 heure
          refresh_token: refreshToken
        });
      }
      
      // Grant type: refresh_token (actualisation d'un token)
      else if (grant_type === 'refresh_token') {
        const { refresh_token } = req.body;
        
        // Vérifier que le refresh token existe
        const tokenRecord = await OAuthToken.findOne({
          where: { refreshToken: refresh_token }
        });
        
        if (!tokenRecord) {
          return res.status(401).json({ error: 'Refresh token invalide' });
        }
        
        // Vérifier que le token n'est pas expiré
        if (new Date() > tokenRecord.expiresAt) {
          await tokenRecord.destroy();
          return res.status(401).json({ error: 'Refresh token expiré' });
        }
        
        // Supprimer l'ancien token
        await tokenRecord.destroy();
        
        // Générer des nouveaux tokens
        const { accessToken, refreshToken } = await generateTokens(tokenRecord.userId);
        
        // Envoyer la réponse
        return res.json({
          access_token: accessToken,
          token_type: 'Bearer',
          expires_in: 3600, // 1 heure
          refresh_token: refreshToken
        });
      }
      
      // Grant type non supporté
      else {
        return res.status(400).json({ error: 'Grant type non supporté' });
      }
    } catch (error) {
      console.error('Erreur d\'authentification:', error);
      return res.status(500).json({ error: 'Erreur serveur' });
    }
  },
  
  // Inscription d'un nouvel utilisateur
  async signup(req, res) {
    try {
      const { username, password, name } = req.body;
      
      // Vérifier si l'utilisateur existe déjà
      const existingUser = await User.findOne({ where: { username } });
      if (existingUser) {
        return res.status(400).json({ error: 'Ce nom d\'utilisateur est déjà pris' });
      }
      
      // Créer un nouvel utilisateur
      const user = await User.create({
        username,
        password, // Le hook beforeCreate va hasher le mot de passe
        name
      });
      
      return res.status(201).json({
        message: 'Utilisateur créé avec succès',
        userId: user.id
      });
    } catch (error) {
      console.error('Erreur lors de l\'inscription:', error);
      return res.status(500).json({ error: 'Erreur serveur' });
    }
  }
};

module.exports = authController;
