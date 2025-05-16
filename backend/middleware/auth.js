const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Middleware pour vérifier l'authentification
const auth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Accès non autorisé' });
    }
    
    const token = authHeader.split(' ')[1];
    
    // Vérifier le token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Trouver l'utilisateur associé au token
    const user = await User.findByPk(decoded.userId);
    
    if (!user) {
      return res.status(401).json({ error: 'Accès non autorisé' });
    }
    
    // Ajouter l'utilisateur à la requête
    req.user = user;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Accès non autorisé' });
  }
};

module.exports = auth;
