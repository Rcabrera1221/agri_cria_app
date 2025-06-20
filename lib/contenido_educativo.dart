import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa el paquete

class ContenidoEducativoScreen extends StatelessWidget {
  const ContenidoEducativoScreen({super.key});

  // Función para lanzar URLs
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      // Si no se puede lanzar la URL, muestra un mensaje de error o loguéalo.
      // En una app real, podrías mostrar un SnackBar.
      print('No se pudo abrir la URL: $urlString');
      // Puedes añadir un SnackBar aquí:
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('No se pudo abrir el recurso')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 180,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/ganado_background.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 40.0, left: 20.0),
            child: const Text(
              'Contenido Educativo',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              // Nuevas tarjetas de recursos
              ResourceCard(
                title: 'Video riego eficiente',
                color: Colors.yellow.shade700,
                icon: Icons.play_arrow,
                onTap: () {
                  _launchUrl('https://www.youtube.com/watch?v=jFOruH080yg');
                },
              ),
              const SizedBox(height: 15),
              ResourceCard(
                title: 'Video fertilización',
                color: Colors.yellow.shade700,
                icon: Icons.play_arrow,
                onTap: () {
                  _launchUrl('https://www.youtube.com/watch?v=qtkEWuMUVZI');
                },
              ),
              const SizedBox(height: 15),
              ResourceCard(
                title: 'Guía riego por goteo',
                color: Colors.orange.shade700,
                icon: Icons.menu,
                onTap: () {
                  _launchUrl(
                      'https://www.gob.pe/institucion/senasa/colecciones/1288-guias-de-buenas-practicas-agricolas');
                },
              ),
              const SizedBox(height: 15),
              ResourceCard(
                title: 'Blog cosecha óptima',
                color: Colors.orange.shade700,
                icon: Icons.menu,
                onTap: () {
                  _launchUrl('https://www.netafim.pe/blog/');
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ResourceCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const ResourceCard({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 30,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
