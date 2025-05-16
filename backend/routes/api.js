const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

// Route protégée nécessitant une authentification
router.get('/secret', auth, (req, res) => {
  res.json({ 
    message: 'Vous avez accédé à la zone secrète!',
    user: {
      id: req.user.id,
      username: req.user.username,
      name: req.user.name
    }
  });
});

module.exports = router;
