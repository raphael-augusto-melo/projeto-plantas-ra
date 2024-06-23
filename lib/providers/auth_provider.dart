import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '121944115603-flpqhcanfkbu6r3f8s9chulac4pjk6ie.apps.googleusercontent.com',
  );

  var authStateChanges;

  User? get user => _user;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("SignIn Error: $e");
      // Handle error, possibly by rethrowing or showing a dialog
    }
  }

  Future<void> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Save user info to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
      });
    } catch (e) {
      print("Register Error: $e");
      // Handle error, possibly by rethrowing or showing a dialog
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser;

      if (kIsWeb) {
        googleUser = await _googleSignIn.signInSilently();
      } else {
        googleUser = await _googleSignIn.signIn();
      }

      if (googleUser == null) {
        print("SignIn Aborted: The user canceled the sign-in");
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Save user info to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'email': userCredential.user?.email,
      });

    } catch (e) {
      print("Google SignIn Error: $e");
      // Handle error, possibly by rethrowing or showing a dialog
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print("SignOut Error: $e");
      // Handle error, possibly by rethrowing or showing a dialog
    }
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    if (user != null) {
      _saveUserToLocal(user);
    } else {
      _removeUserFromLocal();
    }
    notifyListeners();
  }

  Future<void> _saveUserToLocal(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', user.email!);
  }

  Future<void> _removeUserFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
  }
}
