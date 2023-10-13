// ignore_for_file: use_build_context_synchronously

import 'package:dart_date/dart_date.dart';
import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/databases/setting_database.dart';
import 'package:disiplean_clone/providers/setting_provider.dart';
import 'package:disiplean_clone/providers/user_provider.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_app_bar.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_bottom_sheet.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_box_widget.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_button_widget.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_list_tile.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AuditScheduleScreen extends StatefulWidget {
  const AuditScheduleScreen({super.key});

  @override
  State<AuditScheduleScreen> createState() => _AuditScheduleScreenState();
}

class _AuditScheduleScreenState extends State<AuditScheduleScreen> {
  // Week Index for tracking week by number
  int? _weekIndex;
  DateTime? _auditSchedule;

  // List of week on a month
  final List<String> _weeks = [
    "Pertama",
    "Kedua",
    "Ketiga",
    "Keempat",
    "Terakhir",
  ];

  // Function to convert _weekIndex to Schedule
  /// set date base on selected week
  DateTime getSelectedStartDate(int week) {
    /// get current date
    final DateTime now = DateTime.now();

    /// define total week on this month
    int totalWeek = now.endOfMonth.getWeek - now.startOfMonth.getWeek;

    /// Step 0 - if total week on this month is only 4 but user select lastest week, then week will be decrease by one
    if (week == 4 && totalWeek <= 4) week = 3;

    /// Step 1 - get the first day of month, and first day on the week
    /// step 2 - add 1 day to be on monday
    /// step 3 - if the first day on the month is monday dont next the week
    DateTime startDateOfFirstWeek = now.startOfMonth.startOfWeek.addDays(1).addWeeks(now.startOfMonth.isSunday ? 0 : 1);

    /// step 4 -  select start date base on the selected week
    DateTime selectedStartTimeOfWeek = startDateOfFirstWeek.addWeeks(week);

    /// step 5 - if $now is greater than $selectedStartTimeOfWeek, then week will be set to week of the next month
    if (now.compareTo(selectedStartTimeOfWeek) >= 0) {
      selectedStartTimeOfWeek = selectedStartTimeOfWeek.addWeeks(totalWeek);
    }

    return selectedStartTimeOfWeek;
  }

  // Function to get audit schedule
  void getAuditSchedule() {
    // print("DEBUG: ${Provider.of<SettingProvider>(context, listen: false).settingData['audit_setting']['schedule']['week']}");
    setState(() {
      _weekIndex = Provider.of<SettingProvider>(context, listen: false).settingData['audit_setting']['schedule']['week'] ?? -1;
      _auditSchedule = getSelectedStartDate(_weekIndex!);
    });
  }

  // Function to save audit schedule
  void saveAuditSchedule() async {
    // Get `createdBy` from user provider uid
    final String createdBy = "user-${Provider.of<UserProvider>(context, listen: false).userData['uid']}";

    // Save Audit Schedule
    Map response = await SettingDatabase.saveAuditSchedule(
      week: _weekIndex!,
      createdBy: createdBy,
    );

    ReusableSnackBar.show(context, response['message']);
  }

  @override
  void initState() {
    Future(() {
      // call get audit schedule
      getAuditSchedule();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReusableAppBar(title: "Tanggal Audit"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 26),
        child: Column(
          children: [
            ReusableBoxWidget(
              title: "Jadwal Audit",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pelaksanaan audit dilakukan pada setiap bulan dan akan berlangsung selama 7 hari",
                    style: smNormalTextStyle,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Jadwal audit yang akan datang:",
                    style: mdBoldTextStyle,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _auditSchedule == null ? "Pilih minggu terlebih dahulu" : "${DateFormat('d MMMM yyyy').format(_auditSchedule!)} - ${DateFormat('d MMMM yyyy').format(_auditSchedule!.addDays(6))}",
                    style: mdMediumTextStyle.copyWith(color: accentColor),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            ReusableBoxWidget(
              title: "Pilih Minggu",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableListTile(
                    title: _weekIndex == null ? "Pilih minggu..." : "Minggu ${_weeks[_weekIndex!]}",
                    trailing: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      size: 32,
                      color: darkColor,
                    ),
                    onTap: () {
                      ReusableBottomSheet.buildModalBottom(
                        context: context,
                        title: "Pilih Minggu",
                        child: ListView.builder(
                          itemCount: _weeks.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: ReusableListTile(
                                title: _weeks[index],
                                backgroundType: ListTileBackgroundType.dark,
                                onTap: () {
                                  setState(() {
                                    _weekIndex = index;
                                    _auditSchedule = getSelectedStartDate(_weekIndex!);
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(26),
        child: ReusableButtonWidget(
          label: "Simpan",
          type: ButtonType.primary,
          onPressed: saveAuditSchedule,
        ),
      ),
    );
  }
}
