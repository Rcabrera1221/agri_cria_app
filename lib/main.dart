import 'package:agri_cria_app/actividades_screen.dart';
import 'package:agri_cria_app/agricultor_menu_screen.dart';
import 'package:agri_cria_app/agricultor_screen.dart';
import 'package:agri_cria_app/asesoramiento_ganadero_screen.dart';
import 'package:agri_cria_app/chat_ia_ganadero_screen.dart';
import 'package:agri_cria_app/contenido_educativo_ganadero.dart';
import 'package:agri_cria_app/detalle_actividad_screen.dart';
import 'package:agri_cria_app/ganadero_screen.dart';
import 'package:agri_cria_app/asesoramiento_especialista_screen.dart';
import 'package:agri_cria_app/asesoramiento_screen.dart';
import 'package:agri_cria_app/chat_ia_screen.dart';
import 'package:agri_cria_app/contenido_educativo.dart';
import 'package:agri_cria_app/dashboard_agricultor_screen.dart';
import 'package:agri_cria_app/dashboard_screen.dart';
import 'package:agri_cria_app/datos_personales.dart';
import 'package:agri_cria_app/ganadero_menu_screen.dart';
import 'package:agri_cria_app/home_screen.dart';
import 'package:agri_cria_app/notificaciones_screen.dart';
import 'package:agri_cria_app/registrar_actividad_screen.dart';
import 'package:agri_cria_app/reporte_agricultor_screen.dart';
import 'package:agri_cria_app/reporte_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const AgriCriaApp());
}

class AgriCriaApp extends StatelessWidget {
  const AgriCriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri Cría',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/ganadero': (context) => const GanaderoScreen(),
        '/agricultor': (context) => const AgricultorScreen(),
        '/ganadero-menu': (context) => const GanaderoMenuScreen(),
        '/agricultor-menu': (context) => const AgricultorMenuScreen(),
        '/asesoramiento': (context) => const AsesoramientoScreen(),
        '/asesoramientoGanadero': (context) =>
            const AsesoramientoGanaderoScreen(),
        '/registrar': (context) => const RegistrarActividadScreen(),
        '/reporte': (context) => const ReportesGanaderoScreen(),
        '/reporteAgricultor': (context) => const ReportesAgricultorScreen(),
        '/datosPersonales': (context) => const DatosPersonalesScreen(),
        '/notificaciones': (context) => const NotificationsScreen(),
        '/contenidoEducativo': (context) => const ContenidoEducativoScreen(),
        '/contenidoEducativoGanadero': (context) =>
            const ContenidoEducativoGanaderoScreen(),
        '/asesoramientoEspecialista': (context) =>
            const AsesoramientoEspecialistaScreen(),
        '/asesoramientoIA': (context) => const ChatIAScreen(),
        '/asesoramientoIAGanadero': (context) => const ChatIAGanaderoScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/dashboardAgricultor': (context) => const DashboardAgricultorScreen(),
        '/actividades': (context) => const ActividadesScreen(),
        '/detalleActividades': (context) => const DetalleActividadScreen(
              fecha: '',
              comentario: '',
            )
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> login() async {
    String login = _loginController.text.trim();
    String password = _passwordController.text.trim();

    if (login.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Por favor ingresa usuario y contraseña");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      //final url = Uri.parse('http://192.168.43.189:3000/api/login');
      final url = Uri.parse(
          'https://api-agri-cria-production.up.railway.app/api/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"login": login, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);

        Fluttertoast.showToast(msg: "Login exitoso");
        Navigator.pushNamed(context, '/home');
      } else {
        Fluttertoast.showToast(msg: data['message'] ?? 'Login fallido');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error de conexión');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Image.asset('assets/logo.jpeg', height: 120),
                  const SizedBox(height: 16),
                  const Text('¿Ya tienes una cuenta?',
                      style: TextStyle(color: Colors.white)),
                  const Text('Iniciar sesión en Agri Cría',
                      style: TextStyle(color: Colors.yellow)),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: '¿No tienes una cuenta? ',
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'Regístrate ahora',
                          style: const TextStyle(
                            color: Colors.yellow,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaginaRegistro(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      hintText: 'User Name',
                      filled: true,
                      fillColor: Colors.white70,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white70,
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          icon: const Icon(Icons.login),
                          label: const Text("Iniciar sesión"),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaginaRegistro extends StatefulWidget {
  const PaginaRegistro({super.key});

  @override
  State<PaginaRegistro> createState() => _PaginaRegistroState();
}

class _PaginaRegistroState extends State<PaginaRegistro> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Por favor completa todos los campos");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      //final url = Uri.parse('http://192.168.43.189:3000/api/register');
      final url = Uri.parse(
          'https://api-agri-cria-production.up.railway.app/api/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "email": email,
          "login": username,
          "password": password
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Registro exitoso");
        Navigator.pushNamed(context, '/');
      } else {
        Fluttertoast.showToast(msg: data['message'] ?? 'Error en el registro');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error de conexión');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Image.asset('assets/logo.jpeg', height: 120),
                  const SizedBox(height: 16),
                  const Text('Crea tu cuenta Agri Cria',
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      filled: true,
                      fillColor: Colors.white70,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white70,
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'User Name',
                      filled: true,
                      fillColor: Colors.white70,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white70,
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          icon: const Icon(Icons.person_add),
                          label: const Text("Registrarse"),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
