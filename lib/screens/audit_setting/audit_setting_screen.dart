import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/databases/setting_database.dart';
import 'package:disiplean_clone/providers/user_provider.dart';
import 'package:disiplean_clone/screens/audit_setting/audit_schedule/audit_schedule_screen.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_app_bar.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuditSettingScreen extends StatelessWidget {
  const AuditSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const ReusableAppBar(title: "Pengaturan Audit"),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 26),
          child: Column(
            children: [
              ReusableListTile(
                title: "Tanggal Audit",
                backgroundType: ListTileBackgroundType.dark,
                height: 64,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ligthColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.add_alarm_rounded,
                    color: darkColor,
                    size: 28,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AuditScheduleScreen()));
                },
              ),
              const SizedBox(height: 24),
              ReusableListTile(
                title: "Auditor",
                backgroundType: ListTileBackgroundType.dark,
                height: 64,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ligthColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.group,
                    color: darkColor,
                    size: 28,
                  ),
                ),
                onTap: () {},
              ),
              const SizedBox(height: 24),
              ReusableListTile(
                title: "Ketentuan Penilaian Area",
                backgroundType: ListTileBackgroundType.dark,
                height: 64,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ligthColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.settings,
                    color: darkColor,
                    size: 28,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ));
  }
}
