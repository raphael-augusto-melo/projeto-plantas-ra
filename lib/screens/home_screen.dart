import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'plant_scan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Início', style: GoogleFonts.roboto(color: Colors.white)),
        backgroundColor: const Color(0xFF467302),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40), // Espaçamento para centralizar no início
                Text(
                  'Seja bem vindo ao Panda´s Plant!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/panda_beleza.gif',
                height: 100,
                semanticLabel: 'Animação de um panda falando',
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 100,
              height: 100,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF467302),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PlantScanScreen()),
                  );
                },
                shape: const CircleBorder(),
                elevation: 5.0,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Text(
                  'Escanear\nPlanta',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF8C5D42),
    );
  }
}
