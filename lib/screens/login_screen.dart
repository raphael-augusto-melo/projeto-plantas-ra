import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as auth_provider;
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;
                await Provider.of<auth_provider.AuthProvider>(context, listen: false)
                    .signIn(email, password);
              },
              child: const Text('Login'),
            ),
            if (!kIsWeb) // Hide button for web
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<auth_provider.AuthProvider>(context, listen: false)
                      .signInWithGoogle();
                },
                child: const Text('Login with Google'),
              ),
            if (kIsWeb) // Use renderButton for web
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await Provider.of<auth_provider.AuthProvider>(context, listen: false)
                        .signInWithGoogle();
                  },
                  child: const Text('Login with Google'),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
