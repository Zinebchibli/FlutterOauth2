# Flutter OAuth2 Login avec PostgreSQL

Cette application est un exemple d'implémentation de login OAuth2 dans Flutter, avec un backend Express.js et une base de données PostgreSQL.

## Architecture du projet

- **Frontend**: Application Flutter avec authentification OAuth2
- **Backend**: Serveur Express.js avec PostgreSQL

## Diagramme de séquence

Le diagramme ci-dessous illustre le flux d'authentification OAuth2 implémenté dans cette application:

![Diagramme de séquence OAuth2](digramSequence.png)

### Flux d'authentification
1. L'utilisateur s'inscrit ou se connecte via l'application Flutter
2. Le serveur backend valide les identifiants et génère un access_token et un refresh_token
3. L'application stocke ces tokens de manière sécurisée
4. Pour chaque requête API, l'intercepteur ajoute le token d'accès
5. Lorsqu'un token expire (erreur 401), l'application utilise automatiquement le refresh_token pour obtenir de nouveaux tokens
6. Le backend vérifie la validité du refresh_token et émet de nouveaux tokens si valide

## Configuration requise

- Flutter (dernière version stable)
- Node.js et npm
- PostgreSQL

## Installation

### Configuration du backend (Express.js + PostgreSQL)

1. Configurez PostgreSQL en suivant les instructions dans [INSTALLATION_POSTGRESQL.md](INSTALLATION_POSTGRESQL.md)
2. Installez les dépendances du backend:
   ```bash
   cd backend
   npm install
   ```
3. Démarrez le serveur backend:
   ```bash
   npm run dev
   ```

### Configuration de l'application Flutter

1. Installez les dépendances Flutter:
   ```bash
   flutter pub get
   ```
2. Exécutez l'application:
   ```bash
   flutter run
   ```

## Fonctionnalités

- Authentification OAuth2 avec token et refresh token
- Stockage sécurisé des tokens avec Flutter Secure Storage
- API sécurisée avec intercepteurs HTTP
- Base de données PostgreSQL pour le stockage des utilisateurs et des tokens
