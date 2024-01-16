import 'package:dart_date/dart_date.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/databases/audit_database.dart';
import 'package:disiplean_clone/databases/setting_database.dart';
import 'package:disiplean_clone/screens/auditing/list_audit_location.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SelectDateAudit extends StatefulWidget {
  static const String id = 'selectDateAudit';

  const SelectDateAudit({Key? key}) : super(key: key);

  @override
  _SelectDateAuditState createState() => _SelectDateAuditState();
}

class _SelectDateAuditState extends State<SelectDateAudit> {
  int? _week;
  String organizationId = '';
  DateTime? _dateStart;
  DateTime? _dateEnd;
  String _auditScheduleBtn = "auditScheduleBtn";
  bool _isWeekSelected = false;
  DateTime? _selectedStartDate;

  /// set date base on selected week
  DateTime getSelectedStartDate(int week) {
    /// get current date
    final DateTime now = DateTime.now();
    int totalWeek = now.endOfMonth.getWeek - now.startOfMonth.getWeek;
    if (week == 4 && totalWeek <= 4) week = 3;
    DateTime startDateOfFirstWeek = now.startOfMonth.startOfWeek.addDays(1)
        .addWeeks(now.startOfMonth.weekday == 1 ? 0 : 1);
    DateTime selectedStartTimeOfWeek = startDateOfFirstWeek.addWeeks(week);
    return selectedStartTimeOfWeek;
  }

  /// Set the initial selected date based on the saved week.
  void setInitialSelectedDate(week) {
    // week -1 mean no week selected
    if (week != -1) {
      _isWeekSelected = true;
      _selectedStartDate = getSelectedStartDate(week);
      setState(() {
        _auditScheduleBtn = "${DateFormat('d MMM').format(_selectedStartDate!)} "
            "- ${DateFormat('d MMM yyyy').format(_selectedStartDate!.addDays(6))}";
        _dateStart = _selectedStartDate!;
        _dateEnd = _selectedStartDate!.addDays(6);
      });
    }
  }

  /// Calculate the remaining days
  int calculateRemainingDays() {
    if (_dateEnd == null) {
      return 0;
    } else {
      final DateTime now = DateTime.now();
      final Duration remainingDuration = _dateEnd!.difference(now);
      return remainingDuration.inDays;
    }
  }

  @override
  void initState() {
    Future(() async {
      _week = await SettingDatabase.getAuditWeek(context: context);
      setInitialSelectedDate(_week);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReusableScaffold(
      appBarTitle: "Select Date Audit",
      // resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: const Text('Select Audit Date'),
      //   backgroundColor: const Color(0xFF6D9773),
      //   titleTextStyle: smNormalTextStyle.copyWith(
      //       color: Colors.white,
      //       fontSize: 18
      //   ),
      // ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 25,
          right: 25,
          top: 16,
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                  'Selamat datang di halaman untuk mengaudit lokasi, perhatikan informasi'
                  ' dibawah ini dan pastikan durasi audit sudah sesuai',
                  style: smNormalTextStyle.copyWith(fontSize: 14),
              textAlign: TextAlign.justify,),
            ),
            Text('Jadwal audit', style: smNormalTextStyle.copyWith(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.only(top: 7, bottom: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 16),
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF6D9773),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _auditScheduleBtn.toString(),
                    style: smNormalTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Text('Audit akan berakhir dalam', style: smNormalTextStyle.copyWith(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 16),
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF6D9773),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${calculateRemainingDays()} hari',
                    style: smNormalTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 36),
              child: Text(
                  'Pastikan anda mengaudit lokasi dengan lengkap dan sesuai dengan keadaan yang '
                  'sebenarnya.',
                  style: smNormalTextStyle.copyWith(fontSize: 14)),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListAuditLocation(isChildLocation: false),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFF6D9773)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Lets Audit',
                      style: smNormalTextStyle.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
