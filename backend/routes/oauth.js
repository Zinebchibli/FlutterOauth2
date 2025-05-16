const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// Route pour l'authentification OAuth2 (génération de tokens)
router.post('/token', authController.oauthToken);

// Route pour l'inscription d'un nouvel utilisateur
router.post('/signup', authController.signup);

module.exports = router;
