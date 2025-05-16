## Serveur Backend PostgreSQL pour Flutter OAuth2 Login

Ce dossier contient le serveur backend Express.js avec PostgreSQL pour l'application Flutter OAuth2 Login.

### Prérequis

1. Node.js et npm installés
2. PostgreSQL installé et configuré
3. Base de données `oauth_app` créée

### Installation

1. Créer une base de données PostgreSQL:
```bash
psql -U postgres
CREATE DATABASE oauth_app;
\q
```

2. Installer les dépendances:
```bash
npm install
```

3. Configurer le fichier `.env` avec vos identifiants PostgreSQL.

### Démarrage

```bash
npm run dev
```

Le serveur sera disponible sur http://localhost:3000

### Points d'API

- POST `/oauth/signup` - Inscription d'un nouvel utilisateur
- POST `/oauth/token` - Authentification OAuth2 (obtenir des tokens)
- GET `/secret` - Route protégée nécessitant une authentification
