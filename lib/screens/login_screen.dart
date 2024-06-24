import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart' as auth_provider;
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // The user canceled the sign-in
      return;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF467302), // Defina a cor de fundo aqui
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Adicione o texto de título aqui
            const Text(
              'Bem-vindo\nFaça seu login',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // Espaço entre o título e a imagem
            // Adicione a imagem aqui
            Image.asset(
              'assets/panda-hi.gif', // Substitua pelo caminho correto da sua imagem
              height: 100, // Ajuste o tamanho conforme necessário
            ),
            const SizedBox(height: 20), // Espaço entre a imagem e os inputs
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white), // Cor do label do input
              ),
            ),
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(color: Colors.white), // Cor do label do input
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,  // Cor do texto do botão
                ),
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  await Provider.of<auth_provider.AuthProvider>(context, listen: false)
                      .signIn(email, password);
                },
                child: const Text('Entrar'),
              ),
            ),
            if (!kIsWeb) // Hide button for web
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<auth_provider.AuthProvider>(context, listen: false)
                      .signInWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Cor do texto do botão
                ),
                child: const Text('Entrar com o Google'),
              ),
            if (kIsWeb) // Use renderButton for web
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,  // Cor do texto do botão
                  ),
                  onPressed: () async {
                    await _signInWithGoogle(context);
                  },
                  child: const Text('Entrar com o Google'),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Cor do texto do botão
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text('Registre-se'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
