import 'package:flutter/material.dart';

class AgricultorMenuScreen extends StatelessWidget {
  const AgricultorMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Organiza e infórmate',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.agriculture, size: 50, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _menuButton("Registrar actividad", () {
                        Navigator.pushNamed(context, '/registrar');
                      }),
                      const SizedBox(height: 16),
                      _menuButton("Reporte y seguimiento", () {
                        Navigator.pushNamed(context, '/reporteAgricultor');
                      }),
                      const SizedBox(height: 16),
                      _menuButton("Notificaciones y alertas", () {
                        Navigator.pushNamed(context, '/notificaciones');
                      }),
                      const SizedBox(height: 16),
                      _menuButton("Asesoramiento", () {
                        Navigator.pushNamed(context, '/asesoramiento');
                      }),
                      const SizedBox(height: 16),
                      _menuButton("Dashboard", () {
                        Navigator.pushNamed(context, '/dashboardAgricultor');
                      }),
                      const SizedBox(height: 16),
                      _menuButton("Actividades", () {
                        Navigator.pushNamed(context, '/actividades');
                      }),
                    ],
                  ),
                ),
                const Spacer(),
                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.black54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/datosPersonales');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _menuButton(String text, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    ),
  );
}
