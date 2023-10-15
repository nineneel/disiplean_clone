import 'dart:async';

import 'package:disiplean_clone/databases/user_database.dart';
import 'package:disiplean_clone/providers/action_bar_provider.dart';
import 'package:disiplean_clone/widgets/home/invitation_confirmation_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier, DiagnosticableTreeMixin {
  Map _userData = {};
  Map _allUserData = {};

  StreamSubscription? _userStreamSuscription;
  StreamSubscription? _allUserStreamSuscription;
  StreamSubscription? _auditorInvitationStreamSuscription;

  Map get userData => _userData;
  Map get allUserData => _allUserData;

  void setUserData() async {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;

    // Use current user UID to get user data
    _userStreamSuscription = UserDatabase.getUserDataStream(userUid: user!.uid).listen((event) {
      if (event.snapshot.value != null) {
        Map userDataSnapshot = event.snapshot.value;
        _userData = userDataSnapshot;
        _userData['key'] = "user_${_userData['uid']}";
        notifyListeners();
      } else {
        _userData = {};
        notifyListeners();
      }
    });
  }

  void setAllUserData() async {
    // Get all user data from user database
    _allUserStreamSuscription = UserDatabase.getAllUserDataStream().listen((event) {
      if (event.snapshot.value != null) {
        Map allUserDataSnapshot = event.snapshot.value;

        if (allUserDataSnapshot.isNotEmpty) {
          _allUserData = allUserDataSnapshot;
        } else {
          _allUserData = {};
        }
        notifyListeners();
      } else {
        _allUserData = {};
        notifyListeners();
      }
    });

    // Update provider
    notifyListeners();
  }

  void setAuditorInvitationData(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Get auditor invitation data from getAuditorInvitationStream from user database
    _auditorInvitationStreamSuscription = UserDatabase.getAuditorInvitationStream(
      userUid: user!.uid,
    ).listen((event) {
      if (event.snapshot.value != null) {
        Provider.of<ActionBarProvider>(context, listen: false).addActionBarWidget(
          actionBarKey: ActionBarKey.auditorInvitation,
          label: "Undangan Sebagai Auditor",
          action: () => InvitationConfirmationBottomSheet.buildModalBottomSheet(context: context),
        );
      } else {
        Provider.of<ActionBarProvider>(context, listen: false).removeActionBarWidget(
          actionBarKey: ActionBarKey.auditorInvitation,
        );
      }
    });
  }

  void disposeProvider() {
    _allUserStreamSuscription?.cancel();
    _userStreamSuscription?.cancel();
    _auditorInvitationStreamSuscription?.cancel();
  }
}
