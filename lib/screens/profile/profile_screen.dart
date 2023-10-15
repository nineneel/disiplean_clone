// ignore_for_file: use_build_context_synchronously

import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/providers/user_provider.dart';
import 'package:disiplean_clone/screens/audit_setting/audit_setting_screen.dart';
import 'package:disiplean_clone/screens/auth/landing_screen.dart';
import 'package:disiplean_clone/services/authentication_service.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_app_bar.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_box_widget.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_button_widget.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_list_tile.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Initial Services
  final AuthenticationService _authenticationService = AuthenticationService();

  // Initial Data
  Map userData = {};

  void _logoutProccess() async {
    Map response = await _authenticationService.logout();

    if (response['success']) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LandingScreen()), (route) => false);
      ReusableSnackBar.show(context, response['message']);
    } else {
      ReusableSnackBar.show(context, response['message']);
    }
  }

  @override
  void initState() {
    // Get user data from UserProvider
    userData = Provider.of<UserProvider>(context, listen: false).userData;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReusableAppBar(title: "Profil"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReusableBoxWidget(
              title: "Profil Saya",
              child: Row(
                children: [
                  const Icon(
                    Icons.account_circle_rounded,
                    size: 70,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userData['name'] ?? "-", style: largeMediumTextStyle),
                      Text(userData['email'] ?? "-", style: mdMediumTextStyle),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ReusableListTile(
              title: "Pengaturan Lokasi",
              onTap: () {},
              leading: Icon(
                Icons.location_pin,
                color: darkColor,
                size: 35,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: darkColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            ReusableListTile(
              title: "Pengaturan Audit",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AuditSettingScreen()));
              },
              leading: Icon(
                Icons.settings,
                color: darkColor,
                size: 35,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: darkColor,
                size: 24,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(26),
        child: ReusableButtonWidget(
          label: "Keluar",
          type: ButtonType.secondary,
          onPressed: _logoutProccess,
        ),
      ),
    );
  }
}
