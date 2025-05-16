import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_oauth2/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import '../helpers/sliderightroute.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  static const String _title = 'Home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: Theme.of(context),
      home: const StatefulHomeWidget(),
    );
  }
}

class StatefulHomeWidget extends StatefulWidget {
  const StatefulHomeWidget({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulHomeWidget> createState() => _StatefulHomeWidget();
}

class _StatefulHomeWidget extends State<StatefulHomeWidget> with SingleTickerProviderStateMixin {
  late final String errMsg = "";
  final storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();
  
  // Variables pour les informations utilisateur
  String userName = "";
  String userEmail = "";
  bool isLoading = true;
  
  // Animation pour le chargement personnalisé
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    
    // Initialiser le contrôleur d'animation pour le spinner
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    if (errMsg.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errMsg),
        ));
      });
    }
    
    // Charger les données utilisateur au démarrage
    getUserData();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future getUserData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      Response resp = await apiService.getUserData();
      if (resp.statusCode == 200) {
        var data = jsonDecode(resp.body);
        // Récupérer les données à partir de la structure correcte
        var userData = data['user'];
        setState(() {
          userName = userData['name'] ?? "Utilisateur";
          // Si 'username' est disponible, utilisons-le comme email
          userEmail = userData['username'] ?? "Pas d'email";
          isLoading = false;
        });
      } else {
        setState(() {
          userName = "Erreur de chargement";
          userEmail = "Impossible de récupérer l'email";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = "Erreur";
        userEmail = "Une erreur s'est produite: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = const Color(0xFF6A1B9A);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        title: Text(
          'Flutter OAuth2',
          style: TextStyle(
            height: 1.171875,
            fontSize: 18.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir',
            onPressed: () {
              getUserData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () async {
              await storage.deleteAll();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(context,
                    SlideRightRoute(
                        page: const LoginScreen(errMsg: 'Utilisateur déconnecté',)));
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.2),
            ],
          ),
        ),
        child: Center(
          child: isLoading 
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spinner de chargement personnalisé
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CustomPaint(
                      painter: SpinnerPainter(
                        animation: _animationController,
                        color: primaryColor,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chargement...',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified_user,
                    size: 80,
                    color: Color(0xFF6A1B9A),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bienvenue dans cette application',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.person, color: theme.colorScheme.primary),
                            title: const Text('Nom'),
                            subtitle: Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(Icons.email, color: theme.colorScheme.primary),
                            title: const Text('Email'),
                            subtitle: Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

// Classe pour dessiner un spinner de chargement personnalisé
class SpinnerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  
  SpinnerPainter({required this.animation, required this.color}) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    
    // Dessiner un arc qui tourne
    const double startAngle = -0.5 * 3.14;
    double sweepAngle = 1.5 * 3.14 * animation.value;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + (animation.value * 2 * 3.14),
      sweepAngle,
      false,
      paint,
    );
    
    // Dessiner des points décoratifs autour
    final smallerRadius = radius * 0.85;
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * 3.14;
      final pointRadius = (i % 2 == 0) ? 3.0 : 2.0;
      Paint dotPaint = Paint()
        ..color = color.withOpacity((i / 8 + animation.value) % 1)
        ..style = PaintingStyle.fill;
      
      final dotCenter = Offset(
        center.dx + smallerRadius * cos(angle),
        center.dy + smallerRadius * sin(angle),
      );
      
      canvas.drawCircle(dotCenter, pointRadius, dotPaint);
    }
  }
  
  @override
  bool shouldRepaint(SpinnerPainter oldDelegate) {
    return true;
  }
}
