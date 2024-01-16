// ignore_for_file: use_build_context_synchronously

import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/databases/setting_database.dart';
import 'package:disiplean_clone/providers/setting_provider.dart';
import 'package:disiplean_clone/providers/user_provider.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_bottom_sheet.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_box_widget.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_button_widget.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_list_tile.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_scaffold.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_snackbar.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';

class AuditProvisionScreen extends StatefulWidget {
  const AuditProvisionScreen({super.key});

  @override
  State<AuditProvisionScreen> createState() => _AuditProvisionScreenState();
}

class _AuditProvisionScreenState extends State<AuditProvisionScreen> {
  // Text controller
  final TextEditingController _titleProvisionController = TextEditingController(text: "");
  final TextEditingController _titleSubProvisionController = TextEditingController(text: "");

  // Icon data for icon picker
  IconData? _iconData;

  // Provision data
  Map _provisionData = {};
  List _provisionDataKey = [];

  void _getProvisionData() {
    _provisionData = Provider.of<SettingProvider>(context, listen: true).settingData['audit_setting']?['provisions'] ?? {};
    _provisionDataKey = _provisionData.keys.toList();
  }

  void _showAddProvisionBottomSheet() {
    // Create function to save new provision
    void saveAuditProvision() async {
      Map response = await SettingDatabase.saveAuditProvision(
        userKey: Provider.of<UserProvider>(context, listen: false).userData['key'],
        titleProvision: _titleProvisionController.text,
        iconDataProvision: _iconData,
      );

      if (response['success']) {
        // reset input data
        _titleProvisionController.text = "";
        _iconData = null;

        Navigator.pop(context);
        ReusableSnackBar.show(context, response['message']);
      } else {
        Navigator.pop(context);
        ReusableSnackBar.show(context, response['message'], isSuccess: false);
      }
    }

    // Create function to show icon picker
    void showIconPicker(setStateBS) async {
      // remove focus from input title provision
      FocusScope.of(context).requestFocus(FocusNode());

      _iconData = await FlutterIconPicker.showIconPicker(
        context,
        iconPackModes: [IconPack.material],
      );

      setStateBS(() {});
    }

    ReusableBottomSheet.buildModalBottom(
      context: context,
      title: "Tambahkan Ketentuan",
      child: StatefulBuilder(builder: (context, setStateBS) {
        return Column(
          children: [
            ReusableTextInputWidget(
              label: "Judul Ketentuan",
              keyboardType: TextInputType.text,
              controller: _titleProvisionController,
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Icon", style: mdBoldTextStyle),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ReusableButtonWidget(
                        label: "Pilih Icon",
                        onPressed: () => showIconPicker(setStateBS),
                        type: ButtonType.small,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: darkColor,
                          ),
                        ),
                        child: _iconData != null ? Icon(_iconData, size: 28) : null,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 36),
            ReusableButtonWidget(
              label: "Tambahkan",
              onPressed: saveAuditProvision,
            ),
          ],
        );
      }),
    );
  }

  void _showRemoveProvisionBottomSheet(provisionId) {
    // Create function to save new provision
    void removeAuditProvision() async {
      Map response = await SettingDatabase.removeAuditProvision(
        provisionId: provisionId,
      );

      if (context.mounted) {
        if (response['success']) {
          Navigator.pop(context);
          ReusableSnackBar.show(context, response['message']);
        } else {
          Navigator.pop(context);
          ReusableSnackBar.show(context, response['message'], isSuccess: false);
        }
      }
    }

    ReusableBottomSheet.buildModalBottom(
      context: context,
      title: "Hapus Ketentuan Audit?",
      primaryButtonLabel: "Hapus",
      primaryButtonOnPress: removeAuditProvision,
      secondaryButtonLabel: "Tidak",
      secondaryButtonOnPress: () => Navigator.pop(context),
    );
  }

  void _showAddSubProvisionBottomSheet(provisionId) {
    // Create function to save new provision
    void saveAuditSubProvision() async {
      Map response = await SettingDatabase.saveAuditSubProvision(
        userKey: Provider.of<UserProvider>(context, listen: false).userData['key'],
        provisionId: provisionId,
        titleSubProvision: _titleSubProvisionController.text,
      );

      if (response['success']) {
        // reset input data
        _titleSubProvisionController.text = "";

        Navigator.pop(context);
        ReusableSnackBar.show(context, response['message']);
      } else {
        Navigator.pop(context);
        ReusableSnackBar.show(context, response['message'], isSuccess: false);
      }
    }

    ReusableBottomSheet.buildModalBottom(
      context: context,
      title: "Tambahkan Sub Ketentuan",
      child: Column(
        children: [
          ReusableTextInputWidget(
            label: "Judul Sub Ketentuan",
            keyboardType: TextInputType.text,
            controller: _titleSubProvisionController,
          ),
          const SizedBox(height: 36),
          ReusableButtonWidget(
            label: "Tambahkan",
            onPressed: saveAuditSubProvision,
          ),
        ],
      ),
    );
  }

  void _showRemoveSubProvisionBottomSheet(provisionId, subProvisionId) {
    // Create function to save new provision
    void removeAuditSubProvision() async {
      Map response = await SettingDatabase.removeAuditSubProvision(
        provisionId: provisionId,
        subProvisionId: subProvisionId,
      );

      if (context.mounted) {
        if (response['success']) {
          Navigator.pop(context);
          ReusableSnackBar.show(context, response['message']);
        } else {
          Navigator.pop(context);
          ReusableSnackBar.show(context, response['message'], isSuccess: false);
        }
      }
    }

    ReusableBottomSheet.buildModalBottom(
      context: context,
      child: ReusableListTile(
        title: "Hapus Sub Ketentuan",
        backgroundType: ListTileBackground.dark,
        leading: Icon(
          Icons.delete,
          color: darkColor,
          size: 32,
        ),
        onTap: removeAuditSubProvision,
      ),
    );
  }

  @override
  void dispose() {
    _titleProvisionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _getProvisionData();
    return ReusableScaffold(
      appBarTitle: "Ketentuan Penilaian Audit",
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
        child: _provisionDataKey.isNotEmpty
            ? ListView.builder(
                itemCount: _provisionDataKey.length,
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
        label: "Tambah Ketentuan",
        onPressed: _showAddProvisionBottomSheet,
      ),
    );
  }

  Widget _buildProvisionBoxWidget(int index) {
    // Get provision data from provision data list
    Map provisionData = _provisionData[_provisionDataKey[index]];
    // Provisioin data
    String provisionId = _provisionDataKey[index];
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
                    return Container(
                      decoration: BoxDecoration(
                        border: BorderDirectional(
                          bottom: BorderSide(
                            width: 1,
                            color: greyColor,
                          ),
                        ),
                      ),
                      child: ReusableListTile(
                        type: ListTileType.secondary,
                        fontSizeType: ListTileFontSize.sm,
                        title: subProvisionTitle,
                        trailing: IconButton(
                          onPressed: () => _showRemoveSubProvisionBottomSheet(provisionId, subProvisionId),
                          icon: Icon(
                            Icons.more_vert,
                            size: 28,
                            color: darkColor,
                          ),
                          padding: const EdgeInsets.all(0),
                          splashRadius: 24,
                        ),
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

              const SizedBox(height: 12),
              // Buttons
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: ReusableButtonWidget(
                      label: "Tambah Sub Ketentuan",
                      type: ButtonType.small,
                      onPressed: () => _showAddSubProvisionBottomSheet(provisionId),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: ReusableButtonWidget(
                      type: ButtonType.small,
                      iconData: Icons.delete_outlined,
                      onPressed: () => _showRemoveProvisionBottomSheet(provisionId),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
