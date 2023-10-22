import 'package:disiplean_clone/databases/user_database.dart';
import 'package:disiplean_clone/models/response.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:uuid/uuid.dart';

final FirebaseDatabase settingRTDB = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL: "https://settings-disiplean-clone.asia-southeast1.firebasedatabase.app/",
);

class SettingDatabase {
  static String _generateNewId() {
    return const Uuid().v1();
  }

  // Audit Schedule
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

      response['success'] = true;
      response['message'] = "Save Audit Schdule Success!";
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
    }

    return response;
  }

  // Auditor
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

  // Audit Provisions
  static Future<Map> saveAuditProvision({
    required String userKey,
    required String titleProvision,
    required IconData? iconDataProvision,
  }) async {
    Map response = {
      "success": true,
      "message": "",
    };

    try {
      if (titleProvision.isEmpty) {
        throw "Provision title cannot be empty!";
      }

      if (iconDataProvision == null) {
        throw "Provision Icon cannot be empty!";
      }

      DatabaseReference auditSettingRef = settingRTDB.ref('audit_setting');

      String newProvisionId = "provision_${_generateNewId()}";
      Map? iconDataProvisionMap = serializeIcon(iconDataProvision);

      if (iconDataProvisionMap == null) {
        throw "Provision Icon cannot be used!";
      }

      // Create new provisions
      Map<String, dynamic> newProvisions = {
        newProvisionId: {
          "created_at": ServerValue.timestamp,
          "created_by": userKey,
          "title": titleProvision,
          "status": "active",
          "icon": iconDataProvisionMap,
        }
      };

      // Update new Provisions
      await auditSettingRef.child("provisions").update(newProvisions);

      response['success'] = true;
      response['message'] = "Add new Provision Success!";
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
    }

    return response;
  }

  static Future<Map> removeAuditProvision({
    required String provisionId,
  }) async {
    Map response = {
      "success": true,
      "message": "",
    };

    try {
      DatabaseReference auditSettingRef = settingRTDB.ref('audit_setting');

      await auditSettingRef.child("provisions").child(provisionId).remove();

      response['success'] = true;
      response['message'] = "Remove provision success!";
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
    }

    return response;
  }

  static Future<Map> saveAuditSubProvision({
    required String titleSubProvision,
    required String provisionId,
    required String userKey,
  }) async {
    Map response = {
      'success': true,
      'message': "",
    };

    try {
      if (titleSubProvision.isEmpty) {
        throw "Title cannot be empty!";
      }

      DatabaseReference auditSettingRef = settingRTDB.ref('audit_setting');

      String newSubProvisionId = "sub_provision_${_generateNewId()}";
      Map<String, dynamic> newSubProvision = {
        newSubProvisionId: {
          "title": titleSubProvision,
          "created_by": userKey,
          "created_at": ServerValue.timestamp,
          "status": "active",
        }
      };

      await auditSettingRef //
          .child('provisions')
          .child(provisionId)
          .child('sub_provision')
          .update(newSubProvision);

      response['success'] = true;
      response['message'] = "Add new subprovision Success!";
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
    }
    return response;
  }

  static Future<Map> removeAuditSubProvision({
    required String provisionId,
    required String subProvisionId,
  }) async {
    Map response = {
      "success": true,
      "message": "",
    };

    try {
      DatabaseReference auditSettingRef = settingRTDB.ref('audit_setting');

      await auditSettingRef.child("provisions").child(provisionId).child("sub_provision").child(subProvisionId).remove();

      response['success'] = true;
      response['message'] = "Remove provision success!";
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
    }

    return response;
  }

  static Future<Map> saveLocation({
    required String userKey,
    required String locationName,
    required bool isChildLocation,
    required bool isNeedAudit,
    String? parentLocationId,
    int? totalParentChildLocations,
  }) async {
    Map response = {
      "success": true,
      "message": "",
    };

    try {
      if (locationName.isEmpty) {
        throw "Location name cannot be empty!";
      }
      DatabaseReference locationSettingRef = settingRTDB.ref("location_setting");

      String newLocationId = "location_${_generateNewId()}";

      Map<String, dynamic> newLocationData = {
        newLocationId: {
          "name": locationName,
          "tag": "#0000", // TODO: Create Tag generator functions
          "created_by": userKey,
          "cerated_at": ServerValue.timestamp,
          "need_audit": isNeedAudit,
        }
      };

      if (isChildLocation) {
        if (parentLocationId == null) {
          throw "Parent Location Id cannot be empty!";
        }

        newLocationData[newLocationId]["parent_location_id"] = parentLocationId;

        int childIdKey = totalParentChildLocations ?? 0;

        await locationSettingRef //
            .child('locations')
            .child(parentLocationId)
            .child("child_locations_id")
            .update({'$childIdKey': newLocationId});
      }

      await locationSettingRef.child("locations").update(newLocationData);

      response['success'] = true;
      response['message'] = "Create new location success!";
    } catch (e) {
      response['success'] = false;
      response['message'] = "$e";
    }

    return response;
  }

  // Getter
  static Stream getSettingDataStream() {
    DatabaseReference settingRef = settingRTDB.ref();
    return settingRef.onValue;
  }
}
