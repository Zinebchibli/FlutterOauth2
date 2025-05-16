@echo off
echo ======================================================
echo Configuration et Démarrage du Backend PostgreSQL OAuth2
echo ======================================================
echo.

cd backend

echo Installation des dépendances npm...
call npm install

echo.
echo Configuration de la base de données...
call npm run setup-db

echo.
echo Démarrage du serveur backend...
call npm run dev
