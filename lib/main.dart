import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:projeto_planta_realidade_aumentada/firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
=======
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:projeto_planta_realidade_aumentada/firebase_options.dart';
>>>>>>> cc4c19be4d0c7edc62410223f8701e468aef39b5

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
<<<<<<< HEAD
=======
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

>>>>>>> cc4c19be4d0c7edc62410223f8701e468aef39b5
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Plant Scanner',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.user != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
