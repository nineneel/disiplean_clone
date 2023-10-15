import 'dart:async';

import 'package:disiplean_clone/databases/setting_database.dart';
import 'package:flutter/foundation.dart';

class SettingProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final Map _settingData = {};

  StreamSubscription? _settingStreamSubscription;

  Map get settingData => _settingData;

  void setSettingData() async {
    // Get setting data stream from setting database.
    _settingStreamSubscription = SettingDatabase.getSettingDataStream().listen((event) async {
      if (event.snapshot.value != null) {
        Map settingDataSnapshot = event.snapshot.value;

        if (settingDataSnapshot.containsKey('audit_setting')) {
          _settingData['audit_setting'] = settingDataSnapshot['audit_setting'];
        } else {
          _settingData['audit_setting'] = null;
        }

        if (settingDataSnapshot.containsKey('location_setting')) {
          _settingData['location_setting'] = settingDataSnapshot['location_setting'];
        } else {
          _settingData['location_setting'] = null;
        }

        notifyListeners();
      } else {
        _settingData['audit_setting'] = null;
        _settingData['location_setting'] = null;
        notifyListeners();
      }
    });
  }

  void disposeProvider() {
    _settingStreamSubscription?.cancel();
  }
}
