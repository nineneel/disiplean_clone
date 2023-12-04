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
    DateTime startDateOfFirstWeek = now.startOfMonth.startOfWeek.addDays(1).addWeeks(now.startOfMonth.weekday == 1 ? 0 : 1);

    /// step 4 -  select start date base on the selected week
    DateTime selectedStartTimeOfWeek = startDateOfFirstWeek.addWeeks(week);

    // /// step 5 - if $now is greater than $selectedStartTimeOfWeek, then week will be set to week of the next month
    // if (now.compareTo(selectedStartTimeOfWeek) >= 0) {
    //   selectedStartTimeOfWeek =
    //       selectedStartTimeOfWeek.addWeeks(totalWeek);
    // }

    return selectedStartTimeOfWeek;
  }

  /// Set the initial selected date based on the saved week.
  void _setInitialSelectedDate(week) {
    // week -1 mean no week selected
    if (week != -1) {
      _isWeekSelected = true;
      _selectedStartDate = _getSelectedStartDate(week);
      setState(() {
        _auditScheduleBtn = "${DateFormat('d MMM').format(_selectedStartDate!)} - ${DateFormat('d MMM yyyy').format(_selectedStartDate!.addDays(6))}";
        _dateStart = _selectedStartDate!;
        _dateEnd = _selectedStartDate!.addDays(6);
        print('dateState di audit = $_dateStart');
        print('dateEnd di audit = $_dateEnd');
      });
    }
  }

  /// Calculate the remaining days until the selected audit date.
  int _calculateRemainingDays() {
    if (_dateEnd == null) {
      return 0; // Jika _dateEnd belum diatur, kembalikan 0
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
      print('week di audit = $_week');
      _setInitialSelectedDate(_week);
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
                    '${_calculateRemainingDays()} hari',
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
