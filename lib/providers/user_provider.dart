import 'package:disiplean_clone/databases/user_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier, DiagnosticableTreeMixin {
  Map _userData = {};

  Map get userData => _userData;

  void setUserData() async {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;
    
    // Use current user UID to get user data
    _userData = await UserDatabase.getUserData(uid: user!.uid);

    // Update provider
    notifyListeners();
  }
}
