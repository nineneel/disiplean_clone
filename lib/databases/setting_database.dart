import 'package:disiplean_clone/databases/user_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

final FirebaseDatabase settingRTDB = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL: "https://settings-disiplean-clone.asia-southeast1.firebasedatabase.app/",
);

class SettingDatabase {
  static String _generateNewId() {
    return const Uuid().v1();
  }

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

  static Future<Map> saveInvitationAuditor({
    required String currentUserKey,
    required List newAuditorKeys,
  }) async {
    Map response = {
      "success": true,
      "message": "",
    };

    try {
      DatabaseReference auditSettingRef = settingRTDB.ref('audit_setting');
      DatabaseReference userRef = userRTDB.ref('users');

      for (String newAuditorKey in newAuditorKeys) {
        String invitationId = "auditor_invitation_${_generateNewId()}";

        Map<String, dynamic> newInvitationAuditorData = {
          'auditor_invitation': {
            'invited_by': currentUserKey,
            'date_invited': ServerValue.timestamp,
            'invitation_id': invitationId,
          }
        };

        Map<String, dynamic> newAuditorData = {
          newAuditorKey: {
            'invited_by': currentUserKey,
            'date_invited': ServerValue.timestamp,
            'status': 'pending',
          }
        };

        Future.wait([
          auditSettingRef.child('auditor').update(newAuditorData),
          userRef.child(newAuditorKey).update(newInvitationAuditorData),
        ]);
      }

      response['message'] = "Save Invitation Auditor Data Success";
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
    }

    return response;
  }

  static Future<Map> removeInvitationAuditor({
    required String auditorKey,
  }) async {
    Map response = {
      "success": true,
      "message": "",
    };

    try {
      DatabaseReference auditSettingRef = settingRTDB.ref('audit_setting');
      DatabaseReference userRef = userRTDB.ref('users');

      await userRef.child(auditorKey).child('auditor_invitation').remove();
      await auditSettingRef.child('auditor').child(auditorKey).remove();

      response['message'] = "Remove Auditor Success";
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
    }

    return response;
  }

  static Future<Map> acceptInvitationAuditor({
    required String userKey,
  }) async {
    Map response = {
      "success": true,
      "message": "",
    };

    try {
      DatabaseReference userRef = userRTDB.ref('users');
      DatabaseReference auditSettingRef = settingRTDB.ref('audit_setting');

      await userRef.child(userKey).child("auditor_invitation").remove();
      await auditSettingRef.child("auditor").child(userKey).update({
        'status': 'active',
        'joined_at': ServerValue.timestamp,
      });

      response['message'] = "Accept Invitation Success";
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
    }

    return response;
  }

  static Future<Map> rejectInvitationAuditor({
    required String userKey,
  }) async {
    Map response = {
      "success": true,
      "message": "",
    };

    try {
      DatabaseReference userRef = userRTDB.ref('users');
      DatabaseReference auditSettingRef = settingRTDB.ref('audit_setting');

      await userRef.child(userKey).child("auditor_invitation").remove();
      await auditSettingRef.child("auditor").child(userKey).remove();

      response['message'] = "Reject Invitation Success";
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
