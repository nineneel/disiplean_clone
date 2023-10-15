import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:uuid/uuid.dart';

final FirebaseDatabase userRTDB = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL: "https://user-data-disiplean-clone.asia-southeast1.firebasedatabase.app/",
);

class UserDatabase {
  // static String _generateNewId() {
  //   return const Uuid().v1();
  // }

  static Future<Map> registerUser({
    required String name,
    required String? email,
    required String? uid,
  }) async {
    Map response = {
      'success': true,
      'message': "",
    };

    try {
      // Generate new user data
      String newUserId = 'user_$uid';
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
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
    }

    return response;
  }

  static Stream getUserDataStream({required String userUid}) {
    DatabaseReference userRef = userRTDB.ref();
    Stream userDataStream = userRef.child('users').child('user_$userUid').onValue;

    return userDataStream;
  }

  static Stream getAllUserDataStream() {
    DatabaseReference userRef = userRTDB.ref();
    Stream allUserDataStream = userRef.child('users').onValue;
    return allUserDataStream;
  }

  static Stream getAuditorInvitationStream({required String userUid}) {
    DatabaseReference userRef = userRTDB.ref();
    Stream userAuditorInvitationStream = userRef.child('users').child("user_$userUid").child("auditor_invitation").onValue;

    return userAuditorInvitationStream;
  }
}
