import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Map response = {
    'success': true,
    'message': '',
  };

  Future<Map> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      response['message'] = "Login Sucess";
      return response;
    } on FirebaseAuthException catch (e) {
      response['success'] = false;
      response['message'] = e.message;
      return response;
    }
  }

  Future<Map> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      response['message'] = "Logout Success";
      return response;
    } on FirebaseAuthException catch (e) {
      response['success'] = true;
      response['message'] = e.message;
      return response;
    }
  }

  Future<Map> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      response['message'] = "Sign Up Sucess";
      return response;
    } on FirebaseAuthException catch (e) {
      response['success'] = false;
      response['message'] = e.message;
      return response;
    }
  }
}
