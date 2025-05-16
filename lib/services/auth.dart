import 'dart:convert';

import 'package:flutter_oauth2/helpers/constant.dart';
import 'package:http/http.dart';

class AuthService {
  var loginUri = Uri.parse('${Constants.baseUrl}/oauth/token');
  var registerUri = Uri.parse('${Constants.baseUrl}/oauth/signup');  Future<Response?> login(String username, String password) async {
    try {
      print('Tentative de connexion à : ${loginUri.toString()}');
      String client = 'express-client';
      String secret = 'express-secret';
      String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';
      
      // Créer un Map pour les données du formulaire
      Map<String, String> formData = {
        "username": username,
        "password": password,
        "grant_type": "password"
      };
      
      print('Envoi des données : $formData');
      
      // Convertir le Map en chaîne encodée pour le formulaire
      String encodedBody = formData.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      
      print('Corps encodé : $encodedBody');
      
      var res = await post(
          loginUri,
          headers: <String, String>{
            'Authorization': basicAuth,
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
          },
          body: encodedBody
      ).timeout(const Duration(seconds: 10));
      
      print('Réponse de login : ${res.statusCode} - ${res.body}');
      return res;
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      rethrow;
    }
  }  Future<Response?> refreshToken(String token) async {
    try {
      print('Tentative de rafraîchissement du token');
      String client = 'express-client';
      String secret = 'express-secret';
      String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';
      
      // Créer un Map pour les données du formulaire
      Map<String, String> formData = {
        "refresh_token": token,
        "grant_type": "refresh_token"
      };
      
      // Convertir le Map en chaîne encodée pour le formulaire
      String encodedBody = formData.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
          
      print('Corps encodé pour refresh : $encodedBody');  
            
      var res = await post(
          loginUri,
          headers: <String, String>{
            'Authorization': basicAuth,
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
          },
          body: encodedBody
      ).timeout(const Duration(seconds: 10));
      
      print('Réponse de refresh : ${res.statusCode} - ${res.body}');
      return res;
    } catch (e) {
      print('Erreur lors du rafraîchissement du token: $e');
      rethrow;
    }
  }
  Future<Response?> register(String username, String password, String name) async {
    try {
      print('Tentative d\'inscription à : ${registerUri.toString()}');
      var res = await post(
          registerUri,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
          },
          body: {
            "username": username,
            "password": password,
            "name": name
          }
      ).timeout(const Duration(seconds: 10)); // Ajouter un timeout pour éviter d'attendre indéfiniment
      
      print('Réponse du serveur: ${res.statusCode}');
      return res;
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      rethrow; // Relancer l'erreur pour la traiter au niveau supérieur
    }
  }
}