import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oauth2/helpers/sliderightroute.dart';
import 'package:flutter_oauth2/screens/login.dart';
import 'package:flutter_oauth2/services/auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String _title = 'Register';

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
      home: const StatefulRegisterWidget(),
    );
  }
}

class StatefulRegisterWidget extends StatefulWidget {
  const StatefulRegisterWidget({Key? key}) : super(key: key);

  @override
  State<StatefulRegisterWidget> createState() => _StatefulRegisterWidget();
}

class _StatefulRegisterWidget extends State<StatefulRegisterWidget> {
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();
  final _registerFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Définition des couleurs
  final Color primaryColor = const Color(0xFF6A1B9A);
  final Color secondaryColor = const Color(0xFFBA68C8);
  final Color backgroundColor = Colors.white;

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
        child: SingleChildScrollView(
          child: Form(
            key: _registerFormKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                Icon(
                  Icons.person_add,
                  color: primaryColor,
                  size: 80,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 30),
                  child: Text(
                    'Créez votre compte',
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
                _buildFormField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Entrez votre email',
                  icon: Icons.email,
                  validator: (value) {
                    if(value==null) {
                      return 'Veuillez entrer votre email';
                    } else {
                      return EmailValidator.validate(value) ? null: 'Veuillez entrer un email valide';
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildFormField(
                  controller: _passwordController,
                  labelText: 'Mot de passe',
                  hintText: 'Entrez votre mot de passe',
                  icon: Icons.password,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    } else if(value.length < 6) {
                      return '6 caractères minimum';
                    }
                    return null;
                  },
                ),
                _buildFormField(
                  controller: _nameController,
                  labelText: 'Nom',
                  hintText: 'Entrez votre nom complet',
                  icon: Icons.person,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: SizedBox(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width * 1.0,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.app_registration,
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
                        if (_registerFormKey.currentState!.validate()) {
                          _registerFormKey.currentState!.save();
                          // Afficher le spinner avec un message pour l'inscription
                          EasyLoading.show(status: 'Création du compte...');
                          var res = await authService.register(
                              _emailController.text, _passwordController.text, _nameController.text);                        
                          switch (res!.statusCode) {
                            case 200:
                            case 201:  
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text("Inscription réussie ! Vous pouvez maintenant vous connecter."),
                                backgroundColor: primaryColor,
                              ));
                              Navigator.push(
                                  context, SlideRightRoute(page: const LoginScreen(errMsg: 'Inscription réussie',)));
                              break;
                            case 400:
                              EasyLoading.dismiss();
                              var data = jsonDecode(res.body);
                              if (data["error"] != null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(data["error"].toString()),
                                  backgroundColor: Colors.red,
                                ));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Text("Échec de l'inscription"),
                                  backgroundColor: Colors.red,
                                ));
                              }
                              break;
                            default:
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text("Échec de l'inscription"),
                                backgroundColor: Colors.red,
                              ));
                              break;
                          }
                        }
                      },
                      label: const Text("S'INSCRIRE",
                          style: TextStyle(
                            height: 1.171875,
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
                      text: 'Déjà inscrit? ',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                        color: Colors.black87,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Connectez-vous ici',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context,
                                    SlideRightRoute(page: const LoginScreen(errMsg: '',)));
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
  
  Widget _buildFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    required FormFieldValidator<String> validator,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType ?? TextInputType.text,
        style: const TextStyle(color: Colors.black87, fontSize: 16.0),
        decoration: InputDecoration(
          errorStyle: TextStyle(color: secondaryColor),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: primaryColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: secondaryColor, width: 2),
          ),
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
          labelStyle: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Roboto',
            color: primaryColor,
          ),
          hintStyle: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Roboto',
            color: primaryColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}