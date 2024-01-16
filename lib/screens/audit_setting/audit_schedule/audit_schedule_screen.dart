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
import 'package:disiplean_clone/widgets/reusable/reusable_scaffold.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_snackbar.dart';
import 'package:flutter/material.dart';
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
  // bool _isAuditScheduleChange = false;

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
  DateTime _getSelectedStartDate(int week) {
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

  // Function to set the button is disable or not
  bool _isAuditScheduleChange() {
    int initialWeekIndex = Provider.of<SettingProvider>(context, listen: true).settingData['audit_setting']['schedule']['week'] ?? -1;
    return _weekIndex != initialWeekIndex;
  }

  // Function to get audit schedule
  void _getAuditSchedule() {
    setState(() {
      _weekIndex = Provider.of<SettingProvider>(context, listen: false).settingData['audit_setting']['schedule']['week'] ?? -1;
      _auditSchedule = _getSelectedStartDate(_weekIndex!);
    });
  }

  // Function to save audit schedule
  void _saveAuditSchedule() async {
    // Get `createdBy` from user provider uid
    final String createdBy = Provider.of<UserProvider>(context, listen: false).userData['key'];

    // Save Audit Schedule
    Map response = await SettingDatabase.saveAuditSchedule(
      week: _weekIndex!,
      createdBy: createdBy,
    );

    // Show reusable snackbar
    ReusableSnackBar.show(context, response['message']);
  }

  // Function to show
  void _showSelectWeekBottomSheet() {
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
              height: 50,
              fontSizeType: ListTileFontSize.md,
              backgroundType: ListTileBackground.dark,
              onTap: () {
                setState(() {
                  _weekIndex = index;
                  _auditSchedule = _getSelectedStartDate(_weekIndex!);
                });
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _getAuditSchedule();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReusableScaffold(
      appBarTitle: "Tanggal Audit",
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
                    height: 45,
                    title: _weekIndex == null ? "Pilih minggu..." : "Minggu ${_weeks[_weekIndex!]}",
                    fontSizeType: ListTileFontSize.md,
                    trailing: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      size: 28,
                      color: darkColor,
                    ),
                    onTap: _showSelectWeekBottomSheet,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      buttonBottomSheet: ReusableButtonWidget(
        label: "Simpan",
        type: ButtonType.primary,
        onPressed: _saveAuditSchedule,
        disabled: !_isAuditScheduleChange(),
      ),
    );
  }
}
