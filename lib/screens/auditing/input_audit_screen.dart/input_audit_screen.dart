import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/databases/audit_database.dart';
import 'package:disiplean_clone/providers/setting_provider.dart';
import 'package:disiplean_clone/providers/user_provider.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_box_widget.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_button_widget.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_scaffold.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:provider/provider.dart';

class InputAuditScreen extends StatefulWidget {
  const InputAuditScreen({
    super.key,
    required this.locationId,
  });

  final String locationId;

  @override
  State<InputAuditScreen> createState() => _InputAuditScreenState();
}

class _InputAuditScreenState extends State<InputAuditScreen> {
  // Provision data
  Map _provisionData = {};

  // initial audit data
  final Map _auditData = {};
  List _auditDataKeys = [];
  int _totalProvision = 0;
  int _currentTotalProvision = 0;

  void _getProvisionData() {
    _provisionData = Provider.of<SettingProvider>(context, listen: false).settingData['audit_setting']?['provisions'] ?? {};

    _provisionData.forEach((key, value) {
      Map subProvision = {};

      value['sub_provision'].forEach((key, subValue) {
        Map newSubProvision = {};
        newSubProvision['title'] = subValue['title'];
        newSubProvision['score'] = null;

        subProvision[key] = newSubProvision;
        _totalProvision++;
      });

      Map newAuditData = {
        'icon': value['icon'],
        'title': value['title'],
        'sub_provision': subProvision,
      };

      _auditData[key] = newAuditData;
    });

    _auditDataKeys = _auditData.keys.toList();
  }

  void _updateTotalProvision() {
    _currentTotalProvision = 0;
    _auditData.forEach((key, value) {
      value['sub_provision'].forEach((key, valueSub) {
        if (valueSub['score'] != null) {
          _currentTotalProvision++;
        }
      });
    });
  }

  void _saveAuditData() async {
    EasyLoading.show(status: "save audit result..");
    // Map response = await AuditDatabase.saveAuditData(
    //   userKey: Provider.of<UserProvider>(context, listen: false).userData['key'],
    //   auditData: _auditData,
    //   locationId: widget.locationId,
    //   score: (_currentTotalProvision/_totalProvision) * 100,
    //   locationImage: ,
    // );

    // if (context.mounted) {
    //   if (response['success']) {
    //     EasyLoading.dismiss();
    //     Navigator.pop(context);
    //     ReusableSnackBar.show(context, response['message']);
    //   } else {
    //     EasyLoading.dismiss();
    //     ReusableSnackBar.show(context, response['message'], isSuccess: false);
    //   }
    // }
  }

  @override
  void initState() {
    _getProvisionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReusableScaffold(
      appBarTitle: "Auditing",
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
        child: _auditDataKeys.isNotEmpty
            ? ListView.builder(
                itemCount: _auditDataKeys.length,
                itemBuilder: (context, index) {
                  return _buildProvisionBoxWidget(index);
                },
              )
            : Center(
                child: Text(
                "Belum ada ketentuan Audit!",
                style: lgBoldTextStyle,
              )),
      ),
      buttonBottomSheet: ReusableButtonWidget(
        label: "Simpan Penilaian",
        disabled: _totalProvision != _currentTotalProvision,
        onPressed: _saveAuditData,
      ),
    );
  }

  Widget _buildProvisionBoxWidget(int index) {
    // Get provision data from provision data list
    Map provisionData = _auditData[_auditDataKeys[index]];
    // Provisioin data
    String provisionId = _auditDataKeys[index];
    String title = provisionData['title'];
    IconData? icon = deserializeIcon(provisionData['icon'].cast<String, dynamic>());
    // Sub provision
    Map subProvisionList = provisionData['sub_provision'] ?? {};
    List subProvisionKeys = subProvisionList.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: ReusableBoxWidget(
          child: Column(
            children: [
              // Icon & Title
              Row(
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      color: darkColor,
                      size: 32,
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: lgBoldTextStyle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (subProvisionList.isNotEmpty)
                // Sub provisions
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: subProvisionKeys.length,
                  itemBuilder: (context, indexSub) {
                    Map subProvision = subProvisionList[subProvisionKeys[indexSub]];
                    String subProvisionId = subProvisionKeys[indexSub];
                    String subProvisionTitle = subProvision['title'];
                    String? subProvisionScore = subProvision['score'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              subProvisionTitle,
                              style: smMediumTextStyle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _auditData[provisionId]['sub_provision'][subProvisionId]['score'] = '1';
                                    _updateTotalProvision();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: greyColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: subProvisionScore != null && subProvisionScore == '1' ? darkColor : shadowColor,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _auditData[provisionId]['sub_provision'][subProvisionId]['score'] = '0';
                                    _updateTotalProvision();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: greyColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: subProvisionScore != null && subProvisionScore == '0' ? darkColor : shadowColor,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Belum ada sub ketentuan!",
                    style: mdMediumTextStyle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
