// ignore_for_file: use_build_context_synchronously

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
import 'package:provider/provider.dart';

class AuditorScreen extends StatefulWidget {
  const AuditorScreen({super.key});

  @override
  State<AuditorScreen> createState() => _AuditorScreenState();
}

class _AuditorScreenState extends State<AuditorScreen> {
  // Initialize variable
  Map _allUserData = {};
  Map _auditorData = {};
  List _allUserDataKeys = [];
  List _auditorDataKeys = [];

  // Other variable
  List _selectedUserKeys = [];

  // Function go get all user data from provider
  void _getAllUserData() {
    _allUserData = Provider.of<UserProvider>(context, listen: true).allUserData;
    _auditorData = Provider.of<SettingProvider>(context, listen: true).settingData['audit_setting']?['auditor'] ?? {};
    _allUserDataKeys = _allUserData.keys.toList();
    _auditorDataKeys = _auditorData.keys.toList();
  }

  // Function to show more bottom sheet
  void _showMoreBottomSheet(String auditorKey) {
    // Create function to remove editor
    void removeAuditor() async {
      Map response = await SettingDatabase.removeInvitationAuditor(auditorKey: auditorKey);

      if (response['success']) {
        Navigator.pop(context);
        ReusableSnackBar.show(context, response['message']);
      } else {
        ReusableSnackBar.show(context, response['message'], isSuccess: false);
      }
    }

    ReusableBottomSheet.buildModalBottom(
      context: context,
      child: ReusableListTile(
        title: "Remove",
        backgroundType: ListTileBackground.dark,
        leading: Icon(
          Icons.delete,
          size: 32,
          color: darkColor,
        ),
        onTap: removeAuditor,
      ),
    );
  }

  // Function to show add auditor bottom sheet
  void _showAddAuditorBottomSheet() {
    // Function to show confirmation add auditor bottom sheet
    void showConfirmationAddAuditorBottomSheet() {
      // Fungsi untuk untuk menyimpan undangan auditor ke dalam RTDB
      void saveInvitationAuditor() async {
        // Mengambil User ID saat ini
        String currentUserKey = Provider.of<UserProvider>(context, listen: false).userData['key'];

        // Meyimpan undangan dengan User ID dan List dari Pengguna yang dipilih
        // Dengan memanggil Fungsi Statik dari SettingDatabse yaitu saveInvitationAuditor
        Map response = await SettingDatabase.saveInvitationAuditor(
          currentUserKey: currentUserKey,
          newAuditorKeys: _selectedUserKeys,
        );

        // Memeriksa hasil dari proses penyimpanan
        if (response['success']) {
          // Jika berhasil, hilangkan bottom sheet dan tampilkan pesan berhasil
          Navigator.pop(context);
          ReusableSnackBar.show(context, response['message']);
        } else {
          // Jika gagal, tampilkan pesan eror menyimpan
          ReusableSnackBar.show(context, response['message'], isSuccess: false);
        }
      }

      if (_selectedUserKeys.isNotEmpty) {
        // Pop the previouse bottom sheet
        Navigator.pop(context);

        // Call modal bottom sheet
        ReusableBottomSheet.buildModalBottom(
          context: context,
          title: "Kirim Undangan",
          desc: "Undangan akan dikirimkan kepada anggota dibawah. Anda yakin?",
          primaryButtonLabel: "Kirim Undangan",
          primaryButtonOnPress: saveInvitationAuditor,
          secondaryButtonLabel: "Batalkan",
          secondaryButtonOnPress: () => Navigator.pop(context),
          whenComplete: () {
            _selectedUserKeys = [];
          },
          child: Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _selectedUserKeys.length,
              itemBuilder: (context, index) {
                Map userData = _allUserData[_selectedUserKeys[index]];
                String userName = userData['name'];
                return ReusableListTile(
                  title: userName,
                  height: 50,
                  leading: Icon(
                    Icons.account_circle,
                    color: darkColor,
                    size: 36,
                  ),
                  type: ListTileType.secondary,
                );
              },
            ),
          ),
        );
      }
    }

    ReusableBottomSheet.buildModalBottom(
      context: context,
      title: "Pilih Anggota",
      primaryButtonLabel: "Tambahkan Auditor",
      primaryButtonOnPress: showConfirmationAddAuditorBottomSheet,
      child: StatefulBuilder(builder: (context, setStateBS) {
        return Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            // itemCount: 120,
            itemCount: _allUserDataKeys.length,
            itemBuilder: (context, index) {
              Map userData = _allUserData[_allUserDataKeys[index]];
              String userName = userData['name'];
              String userKey = _allUserDataKeys[index];
              bool isAddedAuditor = _auditorDataKeys.contains(userKey);
              bool isSelected = !isAddedAuditor && _selectedUserKeys.contains(userKey);

              return ReusableListTile(
                title: userName,
                height: 50,
                titleColor: isAddedAuditor ? shadowColor : darkColor,
                leading: isSelected
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: greyColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: isSelected ? darkColor : shadowColor,
                        ),
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 36,
                        color: isAddedAuditor ? shadowColor : darkColor,
                      ),
                onTap: () {
                  setStateBS(() {
                    if (!isAddedAuditor) {
                      if (isSelected) {
                        _selectedUserKeys.remove(userKey);
                      } else {
                        _selectedUserKeys.add(userKey);
                      }
                    }
                  });
                },
                type: ListTileType.secondary,
              );
            },
          ),
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Call get all user data function
    _getAllUserData();

    return ReusableScaffold(
      appBarTitle: "Auditor",
      body: Padding(
        padding: const EdgeInsets.fromLTRB(26, 26, 26, 92),
        child: ReusableBoxWidget(
          title: "Daftar Auditor",
          child: _auditorDataKeys.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _auditorDataKeys.length,
                    itemBuilder: (context, index) {
                      Map userData = _allUserData[_auditorDataKeys[index]];
                      Map userAuditorData = _auditorData[_auditorDataKeys[index]];
                      String userKey = "user_${userData['uid']}";
                      String userName = userData['name'];
                      String userStatus = userAuditorData['status'];
                      return ReusableListTile(
                        title: userName,
                        titleColor: userStatus == 'pending' ? shadowColor : darkColor,
                        height: 50,
                        leading: Icon(
                          Icons.account_circle,
                          size: 36,
                          color: userStatus == 'pending' ? shadowColor : darkColor,
                        ),
                        type: ListTileType.secondary,
                        trailing: IconButton(
                          onPressed: () {
                            _showMoreBottomSheet(userKey);
                          },
                          icon: Icon(
                            Icons.more_vert,
                            size: 28,
                            color: darkColor,
                          ),
                          padding: const EdgeInsets.all(0),
                          splashRadius: 24,
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    "Belum ada auditor!",
                    textAlign: TextAlign.center,
                    style: mdBoldTextStyle,
                  ),
                ),
        ),
      ),
      buttonBottomSheet: ReusableButtonWidget(
        label: "Tambahkan Auditor",
        type: ButtonType.primary,
        onPressed: _showAddAuditorBottomSheet,
      ),
    );
  }
}
