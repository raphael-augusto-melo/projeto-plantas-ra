import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyDG55KG31U-GOf4xpcSDItH5ct0Grw2V_Y",
  authDomain: "plantinha-390e3.firebaseapp.com",
  projectId: "plantinha-390e3",
  storageBucket: "plantinha-390e3.appspot.com",
  messagingSenderId: "121944115603",
  appId: "1:121944115603:web:07ce4bae8ebd4464f9c066",
  measurementId: "G-KBESLGX9B0"
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseConfig,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

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

  void _logLoginEvent(String method) {
    FirebaseAnalytics.instance.logEvent(
      name: 'login',
      parameters: <String, dynamic>{
        'method': method,
      },
    ).then((_) {
      print("Login event logged successfully");
    }).catchError((error) {
      print("Failed to log login event: $error");
    });
  }
}
