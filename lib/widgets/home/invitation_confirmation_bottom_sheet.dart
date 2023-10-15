import 'package:disiplean_clone/databases/setting_database.dart';
import 'package:disiplean_clone/providers/user_provider.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_bottom_sheet.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvitationConfirmationBottomSheet {
  static buildModalBottomSheet({
    required BuildContext context,
  }) {
    final String userKey = Provider.of<UserProvider>(context, listen: false).userData['key'];

    void acceptInvitation() async {
      Map response = await SettingDatabase.acceptInvitationAuditor(userKey: userKey);

      if (context.mounted) {
        if (response['success']) {
          Navigator.pop(context);
          ReusableSnackBar.show(context, response['message']);
        } else {
          ReusableSnackBar.show(context, response['message'], isSuccess: false);
        }
      }
    }

    void rejectInvitation() async {
      Map response = await SettingDatabase.rejectInvitationAuditor(userKey: userKey);

      if (context.mounted) {
        if (response['success']) {
          Navigator.pop(context);
          ReusableSnackBar.show(context, response['message']);
        } else {
          ReusableSnackBar.show(context, response['message'], isSuccess: false);
        }
      }
    }

    return ReusableBottomSheet.buildModalBottom(
      context: context,
      title: "Undangan",
      desc: "Terima undangan sebagai Auditor?",
      primaryButtonLabel: "Terima",
      primaryButtonOnPress: acceptInvitation,
      secondaryButtonLabel: "Tidak",
      secondaryButtonOnPress: rejectInvitation,
    );
  }
}
