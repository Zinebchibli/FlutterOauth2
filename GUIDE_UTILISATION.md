# Guide d'installation et d'utilisation

## Installation de PostgreSQL avec l'application Flutter OAuth2 Login

### Étape 1 : Installation de PostgreSQL

1. Téléchargez PostgreSQL depuis [le site officiel](https://www.postgresql.org/download/windows/)
2. Exécutez l'installateur et suivez les instructions
3. Important : Notez le mot de passe que vous définissez pour l'utilisateur 'postgres'
4. Assurez-vous que PostgreSQL est ajouté au PATH de votre système

### Étape 2 : Configuration du projet

1. Ouvrez le fichier `backend/.env` et modifiez les informations de connexion à PostgreSQL :
   ```
   DB_NAME=oauth_app
   DB_USER=postgres
   DB_PASS=votre_mot_de_passe_postgres
   DB_HOST=localhost
   DB_PORT=5432
   ```

2. Assurez-vous que l'URL du backend dans le fichier `lib/helpers/constant.dart` est correcte :
   ```dart
   static const baseUrl = 'http://localhost:3000';
   ```
   
   Si vous exécutez l'application sur un émulateur Android, utilisez plutôt :
   ```dart
   static const baseUrl = 'http://10.0.2.2:3000';
   ```

### Étape 3 : Démarrage du serveur et de l'application

1. **Pour démarrer le serveur backend**, double-cliquez sur le fichier `demarrer-serveur.bat` ou exécutez les commandes suivantes :
   ```
   cd backend
   npm install
   npm run setup-db
   npm run dev
   ```

2. **Pour démarrer l'application Flutter** :
   ```
   flutter pub get
   flutter run
   ```

### Utilisation de l'application

1. Une fois l'application démarrée, vous pouvez vous connecter avec les identifiants de test :
   - Email : `test@example.com`
   - Mot de passe : `password123`

2. Vous pouvez également créer un nouveau compte en utilisant la page d'inscription.

## Résolution des problèmes courants

### Le backend ne se connecte pas à PostgreSQL

- Vérifiez que PostgreSQL est bien démarré
- Assurez-vous que les identifiants dans le fichier `.env` sont corrects
- Vérifiez que le service PostgreSQL est actif dans le Gestionnaire des services

### L'application Flutter ne se connecte pas au backend

- Vérifiez que le serveur backend est bien démarré
- Assurez-vous que l'URL dans `constant.dart` est correcte pour votre environnement
  - `localhost` pour le web
  - `10.0.2.2` pour un émulateur Android
  - Adresse IP réelle de votre machine pour un appareil physique
