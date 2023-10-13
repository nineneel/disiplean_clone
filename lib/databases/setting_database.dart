import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase settingRTDB = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL: "https://settings-disiplean-clone.asia-southeast1.firebasedatabase.app/",
);

class SettingDatabase {
  static Future<Map> saveAuditSchedule({
    required int week,
    required String createdBy,
  }) async {
    Map response = {
      'success': true,
      'message': "",
    };

    try {
      Map<String, String> createdAt = ServerValue.timestamp;

      Map<String, Object> scheduleData = {
        "schedule": {
          "created_at": createdAt,
          "created_by": createdBy,
          "week": week,
        },
      };

      DatabaseReference settingRef = settingRTDB.ref();
      await settingRef.child('audit_setting').update(scheduleData);

      response['message'] = "Save Audit Schdule Success!";
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
    }

    return response;
  }

  static Stream getSettingDataStream() {
    DatabaseReference settingRef = settingRTDB.ref();
    return settingRef.onValue;
  }
}
