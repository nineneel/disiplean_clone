import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/screens/audit_setting/audit_provision/audit_provision_screen.dart';
import 'package:disiplean_clone/screens/audit_setting/audit_schedule/audit_schedule_screen.dart';
import 'package:disiplean_clone/screens/audit_setting/auditor/auditor_screen.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_app_bar.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_list_tile.dart';
import 'package:flutter/material.dart';

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
                backgroundType: ListTileBackground.dark,
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
                backgroundType: ListTileBackground.dark,
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
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AuditorScreen()));
                },
              ),
              const SizedBox(height: 24),
              ReusableListTile(
                title: "Ketentuan Penilaian Area",
                backgroundType: ListTileBackground.dark,
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
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AuditProvisionScreen()));
                },
              ),
            ],
          ),
        ));
  }
}
