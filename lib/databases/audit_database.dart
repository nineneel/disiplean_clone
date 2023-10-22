import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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
    required Map auditData,
    required String userKey,
    required String locationId,
  }) async {
    Map response = {
      'success': true,
      "message": "",
    };

    try {
      DatabaseReference auditRef = auditRTDB.ref();

      int validScore = 0;
      int totalProvision = 0;
      Map auditAssessment = {};

      auditData.forEach((key, value) {
        Map newProvision = {};
        Map newSubProvision = {};

        value['sub_provision'].forEach((key, valueSub) {
          if (valueSub['score'] == '1') validScore++;
          totalProvision++;

          newSubProvision[key] = value['score'];
        });

        newProvision = {
          'sub_provision': newSubProvision,
        };

        auditAssessment[key] = newProvision;
      });

      double auditScore = (validScore / totalProvision) * 100;
      String newAuditDataKey = "audit_${_generateNewId()}";

      Map<String, dynamic> newAuditData = {
        newAuditDataKey: {
          'audited_by': userKey,
          'audited_at': ServerValue.timestamp,
          'location_id': locationId,
          'audit_assessment': auditAssessment,
          'audit_score': auditScore,
        }
      };

      String yearMonth = "${DateTime.now().year}_${DateTime.now().month}";

      await auditRef.child('audit_result').child(yearMonth).child('audits').update(newAuditData);

      response['success'] = true;
      response['message'] = "Save audit result success!";
    } catch (e) {
      response['success'] = true;
      response['message'] = "$e";
    }

    return response;
  }
}
