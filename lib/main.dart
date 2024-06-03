import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:projeto_planta_realidade_aumentada/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Analytics Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [observer],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Analytics Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _logLoginEvent('email');
          },
          child: Text('Log Login Event'),
        ),
      ),
    );
  }

  void _logLoginEvent(String method) async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: 'login',
        parameters: <String, dynamic>{
          'method': method,
        },
      );
      print("Login event logged successfully");
    } catch (error) {
      print("Failed to log login event: $error");
    }
  }
}
