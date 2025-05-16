import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_oauth2/screens/login.dart';
import 'package:flutter_oauth2/screens/register.dart';
import 'package:flutter_oauth2/screens/home.dart'; // Importer la page d'accueil

void main() {
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  // Définition des couleurs pour le loader
  const Color primaryColor = Color(0xFF6A1B9A); // La couleur principale violet foncé
  const Color secondaryColor = Color(0xFFBA68C8); // La couleur secondaire violet clair
  
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass // Type d'indicateur plus joli
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50.0
    ..radius = 12.0
    ..progressColor = primaryColor
    ..backgroundColor = Colors.white
    ..indicatorColor = primaryColor
    ..textColor = primaryColor
    ..maskColor = primaryColor.withOpacity(0.2)
    ..userInteractions = false // Bloquer les interactions pendant le chargement
    ..dismissOnTap = false
    ..infoWidget = Icon(
      Icons.info_outline,
      color: primaryColor,
      size: 30,
    )
    ..successWidget = Icon(
      Icons.check_circle_outline,
      color: Colors.green,
      size: 30,
    )
    ..errorWidget = Icon(
      Icons.error_outline,
      color: Colors.red,
      size: 30,
    )
    ..loadingStyle = EasyLoadingStyle.custom;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth Role',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Nouvelle couleur primaire
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A1B9A), // Couleur violet foncé
          primary: const Color(0xFF6A1B9A),
          secondary: const Color(0xFFBA68C8),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/Login',
      routes: {
        '/Login': (context) => const LoginScreen(errMsg: '',),
        '/Register': (context) => const RegisterScreen(),
        '/Home': (context) => const HomeScreen(), // Ajout de la route vers Home
      },
      builder: EasyLoading.init(),
    );
  }
}
