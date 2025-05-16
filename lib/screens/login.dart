import 'dart:convert';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oauth2/helpers/sliderightroute.dart';
import 'package:flutter_oauth2/screens/home.dart';
import 'package:flutter_oauth2/screens/register.dart';
import 'package:flutter_oauth2/services/auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key, required this.errMsg}) : super(key: key);
  final String errMsg;
  static const String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A1B9A),
          primary: const Color(0xFF6A1B9A),
          secondary: const Color(0xFFBA68C8),
        ),
      ),
      home: StatefulLoginWidget(errMsg: errMsg,),
    );
  }
}

class StatefulLoginWidget extends StatefulWidget {
  const StatefulLoginWidget({Key? key, required this.errMsg}) : super(key: key);
  final String errMsg;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulLoginWidget> createState() => _StatefulLoginWidget(errMsg: errMsg);
}

class _StatefulLoginWidget extends State<StatefulLoginWidget> with SingleTickerProviderStateMixin {
  _StatefulLoginWidget({required this.errMsg});
  final String errMsg;
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  
  // Animation pour le spinner personnalisé
  late AnimationController _animationController;
  
  // Définition des couleurs
  final Color primaryColor = const Color(0xFF6A1B9A);
  final Color secondaryColor = const Color(0xFFBA68C8);
  final Color textColor = Colors.white;
  final Color backgroundColor = Colors.white;

  void checkToken() async {
    var token = await storage.read(key: "token");
    if (token != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, SlideRightRoute(page: const HomeScreen()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();

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
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.1),
              secondaryColor.withOpacity(0.2),
            ],
          ),
        ),
        child: isLoading 
          ? Center(
              child: Column(
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
                    'Connexion en cours...',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Icon(
                      Icons.lock_open,
                      color: primaryColor,
                      size: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 30),
                      child: Text(
                        'Bienvenue, veuillez vous connecter',
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.171875,
                          fontSize: 24.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if(value==null) {
                            return 'Veuillez entrer votre email';
                          } else {
                            return EmailValidator.validate(value) ? null: 'Veuillez entrer un email valide';
                          }
                        },
                        onChanged: (value) {},
                        autocorrect: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: secondaryColor),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                color: primaryColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                color: secondaryColor, width: 2),
                          ),
                          labelText: 'Email',
                          hintText: 'Entrez votre email',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            child: Icon(
                              Icons.email,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                          labelStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Roboto',
                              color: primaryColor),
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Roboto',
                              color: primaryColor.withOpacity(0.5)),
                          filled: true,
                        ),
                        style: TextStyle(
                            color: Colors.black87, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {},
                        autocorrect: true,
                        obscureText: true,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: secondaryColor),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                color: primaryColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                color: secondaryColor, width: 2),
                          ),
                          labelText: 'Mot de passe',
                          hintText: 'Entrez votre mot de passe',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            child: Icon(
                              Icons.password,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                          labelStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Roboto',
                              color: primaryColor),
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Roboto',
                              color: primaryColor.withOpacity(0.5)),
                          filled: true,
                        ),
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: SizedBox(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width * 1.0,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.login,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                )),
                            backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                          ),
                          onPressed: () async {
                            if(_loginFormKey.currentState==null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text("Email ou mot de passe incorrect!"),
                                backgroundColor: primaryColor,
                              ));
                            } else {
                              if (_loginFormKey.currentState!.validate()) {
                                _loginFormKey.currentState!.save();
                                
                                // Activer le mode chargement
                                setState(() {
                                  isLoading = true;
                                });
                                
                                var res = await authService.login(
                                    _emailController.text, _passwordController.text);

                                switch (res!.statusCode) {
                                  case 200:
                                    // Ne pas désactiver le mode chargement ici pour maintenir
                                    // le spinner pendant la redirection
                                    var data = jsonDecode(res.body);
                                    await storage.write(key: "token", value: data['access_token']);
                                    await storage.write(key: "refresh_token", value: data['refresh_token']);
                                    if (!context.mounted) return;
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      Navigator.pushReplacement(
                                          context, SlideRightRoute(page: const HomeScreen()));
                                    });
                                    break;
                                  case 401:
                                    // Désactiver le mode chargement
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: const Text("Email ou mot de passe incorrect!"),
                                      backgroundColor: primaryColor,
                                    ));
                                    break;
                                  default:
                                    // Désactiver le mode chargement
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: const Text("Une erreur est survenue!"),
                                      backgroundColor: primaryColor,
                                    ));
                                    break;
                                }
                              }
                            }
                          },
                          label: const Text('SE CONNECTER',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: RichText(
                        text: TextSpan(
                          text: 'Pas encore inscrit? ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: Colors.black87,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Inscrivez-vous ici',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context,
                                        SlideRightRoute(page: const RegisterScreen()));
                                  },
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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