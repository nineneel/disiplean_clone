import 'package:disiplean_clone/databases/user_database.dart';
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

      response['success'] = true;
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
    } catch (e) {
      response['success'] = true;
      response['message'] = "$e";
      return response;
    }
  }

  Future<Map> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Map registerUserResponse = await UserDatabase.registerUser(
        name: name,
        email: userCredential.user?.email!,
        uid: userCredential.user?.uid,
      );

      if (!registerUserResponse['success']) {
        throw registerUserResponse['message'];
      }

      response['success'] = true;
      response['message'] = "Sign Up Sucess";
      return response;
    } catch (e) {
      response['success'] = false;
      response['message'] = '$e';
      return response;
    }
  }
}
