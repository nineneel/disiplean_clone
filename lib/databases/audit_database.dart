import 'dart:io';

import 'package:disiplean_clone/utils/uploadFileAttachment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

final FirebaseDatabase auditRTDB = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL: "https://audit-disiplean-clone.asia-southeast1.firebasedatabase.app/",
);

class AuditDatabase {
  static String _generateNewId() {
    return const Uuid().v1();
  }

  static Future<Map> saveAuditData({
    required String userKey,
    required String locationId,
    required double score,
    required File locationImage,
    required String comment,
    required BuildContext context,
  }) async {
    Map response = {
      'success': true,
      "message": "",
    };
    try {
      DatabaseReference auditRef = auditRTDB.ref();
      String newAuditDataKey = "audit_${_generateNewId()}";
      String imageUrl = await UploadAttachment()
          .uploadPic(file: locationImage, context: context); /// upload pic
      Map<String, dynamic> newAuditData = {
        newAuditDataKey: {
          'audited_by': userKey,
          'audited_at': ServerValue.timestamp,
          'location_id': locationId,
          'audit_score': score,
          'loc_image': imageUrl,
          'comment': comment,
        }
      };

      String yearMonth = "${DateTime.now().year}_${DateTime.now().month}";

      await auditRef
          .child('audit_result')
          .child(yearMonth)
          .child('audits')
          .update(newAuditData);

      response['success'] = true;
      response['message'] = "Save audit result success!";
    } catch (e) {
      response['success'] = true;
      response['message'] = "$e";
    }

    return response;
  }

  static Future<Map<String, int>> getScoreAuditResultsForMonth({
    required String yearMonth,
    required String locationID,
  }) async {
    DatabaseReference auditRef = auditRTDB.ref();

    DatabaseEvent auditData = await auditRef
        .child('audit_result')
        .child(yearMonth)
        .child('audits')
        .orderByChild('location_id')
        .equalTo(locationID)
        .once();

    Map<String, int> locationScores = {};

    if (auditData.snapshot.value != null) {
      Map<dynamic, dynamic> auditMap = auditData.snapshot.value as Map<dynamic, dynamic>;

      auditMap.forEach((auditId, auditDetails) {
        String locationId = auditDetails['location_id'];
        int score = auditDetails['audit_score'];
        locationScores[locationId] = score;
      });
    }

    return locationScores;
  }
}
