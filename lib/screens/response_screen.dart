import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'home_screen.dart'; 

class ResponseScreen extends StatelessWidget {
  final String responseText;

  const ResponseScreen({required this.responseText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Análise do Panda', style: GoogleFonts.roboto(color: Colors.white)),
        backgroundColor: const Color(0xFF467302),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildChatBubble(responseText),
              ],
            ),
          ),
          _buildPandaAnimator(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF467302),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: MarkdownBody(
          data: text,
          styleSheet: MarkdownStyleSheet(
            p: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
            ),
            strong: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPandaAnimator() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.asset(
            'assets/panda_talking.gif', // Adicione o panda animado aqui
            height: 100,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Panda está falando...',
            style: GoogleFonts.roboto(
              color: const Color(0xFF8C5D42),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
