import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

final FirebaseDatabase userRTDB = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL: "https://user-data-disiplean-clone.asia-southeast1.firebasedatabase.app/",
);

class UserDatabase {
  // static String _generateNewId() {
  //   return const Uuid().v1();
  // }

  static Future<Map> registerUser({required String name, required String? email, required String? uid}) async {
    Map response = {
      'success': true,
      'message': "",
    };

    try {
      // Generate new user data
      String newUserId = 'user-$uid';
      Map<String, Object> newUser = {
        newUserId: {
          'name': name,
          'email': email,
          'uid': uid,
        }
      };

      // Push user data to userRTDB by using update method
      DatabaseReference userRef = userRTDB.ref();
      await userRef.child('users').update(newUser);

      // Print response message
      response['message'] = 'New user added successfully';
      return response;
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
      return response;
    }
  }

  static Future<Map> getUserData({required String uid}) async {
    try {
      DatabaseReference userRef = userRTDB.ref();
      DatabaseEvent userEvent = await userRef.child('users').child('user-$uid').once();

      Map userData = userEvent.snapshot.value as Map;

      return userData;
    } catch (e) {
      return {};
    }
  }
}
