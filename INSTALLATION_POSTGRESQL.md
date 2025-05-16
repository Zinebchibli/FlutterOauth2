# Installation de PostgreSQL pour le projet OAuth2 Flutter

## 1. Installation de PostgreSQL

### Windows

1. Téléchargez PostgreSQL depuis [le site officiel](https://www.postgresql.org/download/windows/)
2. Exécutez l'installateur et suivez les instructions
3. Pendant l'installation, notez le mot de passe que vous définissez pour l'utilisateur 'postgres'
4. Assurez-vous que l'option "Stack Builder" est cochée à la fin de l'installation

## 2. Configuration de la base de données

Une fois PostgreSQL installé, lancez "pgAdmin" (installé avec PostgreSQL) et:

1. Connectez-vous avec les identifiants définis lors de l'installation
2. Cliquez droit sur "Databases" dans l'arborescence et sélectionnez "Create" > "Database"
3. Nommez la base de données `oauth_app` et sauvegardez

## 3. Mise à jour du fichier .env

Modifiez le fichier `.env` dans le dossier backend avec vos identifiants PostgreSQL:

```
DB_NAME=oauth_app
DB_USER=postgres
DB_PASS=votre_mot_de_passe
DB_HOST=localhost
DB_PORT=5432
```

## 4. Démarrage du serveur

Une fois la base de données configurée, vous pouvez démarrer le serveur:

```bash
cd backend
npm run dev
```
