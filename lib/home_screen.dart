import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido centrado
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.jpeg', height: 100),
                const SizedBox(height: 20),
                const Text(
                  '¡Bienvenido a Agri Cria',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _roleOption(
                      icon: Icons
                          .agriculture, // Puedes usar un icono personalizado si lo prefieres
                      label: 'Ganadero',
                      onTap: () {
                        Navigator.pushNamed(context, '/ganadero');
                      },
                    ),
                    const SizedBox(width: 30), // Mayor separación horizontal
                    _roleOption(
                      icon: Icons
                          .person_outline, // Puedes cambiar el icono si tienes otro mejor
                      label: 'Agricultor',
                      onTap: () {
                        Navigator.pushNamed(context, '/agricultor');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Cultivando y criando con sabiduría",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _roleOption({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white,
        child: Icon(
          icon,
          size: 40,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 12),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD6A5), // Color durazno
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}
