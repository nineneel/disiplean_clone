import 'dart:io';

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
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class InputAuditScreenNew extends StatefulWidget {
  const InputAuditScreenNew({
    super.key,
    required this.locationId,
    required this.locationImage,
    required this.locationName,
  });

  final String locationId;
  final String locationName;
  final String locationImage;

  @override
  State<InputAuditScreenNew> createState() => _InputAuditScreenNewState();
}

class _InputAuditScreenNewState extends State<InputAuditScreenNew> {
  // Provision data
  Map _provisionData = {};
  File? selectedImage;
  // initial audit data
  final Map _auditData = {};
  List _auditDataKeys = [];
  int _totalProvision = 0;
  int _currentTotalProvision = 0;
  TextEditingController commentController = TextEditingController();
  int commentMax = 50;
  int commentCount = 0;
  String commentText = '';

  void _getProvisionData() {
    _provisionData = Provider.of<SettingProvider>(context, listen: false)
        .settingData['audit_setting']?['provisions'] ?? {};

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

  // void _saveAuditData() async {
  //   EasyLoading.show(status: "save audit result..");
  //   print('scoreAUdit = ${calculateScore()}');
  //   Map response = await AuditDatabase.saveAuditData(
  //     userKey: Provider.of<UserProvider>(context, listen: false).userData['key'],
  //     locationId: widget.locationId,
  //     score: calculateScore(),
  //     context: context,
  //     locationImage: selectedImage!,
  //     comment: commentText,
  //   );
  //
  //   if (context.mounted) {
  //     if (response['success']) {
  //       EasyLoading.dismiss();
  //
  //     } else {
  //       EasyLoading.dismiss();
  //       ReusableSnackBar.show(context, response['message'], isSuccess: false);
  //     }
  //   }
  // }

  void _saveAuditData() async {
    EasyLoading.show(status: "Saving audit result..");
    try {
      await AuditDatabase.saveAuditData(
        userKey: Provider
            .of<UserProvider>(context, listen: false)
            .userData['key'],
        locationId: widget.locationId,
        score: calculateScore(),
        context: context,
        locationImage: selectedImage!,
        comment: commentText,
      );

      if (context.mounted) {
        EasyLoading.dismiss();
        ReusableSnackBar.show(context,
            "Audit result saved successfully.", isSuccess: true);
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        EasyLoading.dismiss();
        ReusableSnackBar.show(context, "$e", isSuccess: false);
      }
    }
  }

  // Function to pick an image from the device
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Pilih dari Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Pilih dari Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage.path);
    });
  }


  Future pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage.path);
    });
  }

  int calculateAnsweredQuestions() {
    int answeredQuestionsCount = 0;
    for (var map in _auditData.keys) {
      for (var subProvision in _auditData[map]['sub_provision'].values) {
        if (subProvision['score'] != null) {
          answeredQuestionsCount++;
        }
      }
    }
    return answeredQuestionsCount;
  }

  double calculateScore() {
    int correctAnsweredCount = 0;
    for (var map in _auditData.keys) {
      for (var subProvision in _auditData[map]['sub_provision'].values) {
        if (subProvision['score'] != null && subProvision['score'] == '1') {
          correctAnsweredCount++;
        }
      }
    }
    double score = (correctAnsweredCount / _totalProvision) * 100;
    return score.ceilToDouble(); // round up score
  }

  void updateCommentCount(String text) {
    setState(() {
      commentText = text;
      commentCount = text.length;
    });
  }


  @override
  void initState() {
    _getProvisionData();
    print('locationName = ${widget.locationName}');
    print('locationImage = ${widget.locationImage}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReusableScaffold(
      appBarTitle: "Auditing",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 26, right: 26, top: 20),
                child: Container(
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        child: Image.network(
                          widget.locationImage,
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          widget.locationName,
                          style: smNormalTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  _pickImage();
                },
                child: Card(
                  margin: const EdgeInsets.all(26),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                      )
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Show image if selectedImage is not null
                        if (selectedImage != null)
                          Image.file(
                            selectedImage!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        // Show icon and text if selectedImage is null
                        if (selectedImage == null)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                size: 48,
                                color: Colors.black
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pick Image',
                                style: smBoldTextStyle.copyWith(
                                  color: Colors.black,
                                  fontSize: 18
                                )
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  children: [
                    Text(
                      'Poin terisi',
                      style: smNormalTextStyle.copyWith(
                        fontSize: 14
                      ),
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(5),
                        color: Colors.grey.shade200,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 6,
                          right: 6,
                          top: 4,
                          bottom: 4,
                        ),
                        child: Text(
                          '${calculateAnsweredQuestions()}/'
                              '$_totalProvision',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _auditDataKeys.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
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
              /// comment section
              Padding(
                padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 28,
                    left: 26,
                    right: 26
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Komentar',
                          ),
                          Text(
                            '$commentCount/$commentMax',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      /// comment container
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: TextField(
                                controller: commentController,
                                onChanged: updateCommentCount,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Tulis komentar di sini',
                                  hintStyle: TextStyle(
                                    fontSize: 14
                                  )
                                ),
                              ),
                            ),
                          ),
                          if (commentCount > commentMax)
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                'Melebihi batas karakter',
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      buttonBottomSheet: ReusableButtonWidget(
        label: "Simpan Penilaian",
        disabled: (_totalProvision != _currentTotalProvision)
            && selectedImage == null,
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
                                    color: subProvisionScore != null && subProvisionScore == '1' ? const Color(0xFFCCFFCE) : greyColor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: subProvisionScore != null && subProvisionScore == '1' ? const Color(0xFF048519) : greyColor,
                                    )
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: subProvisionScore != null && subProvisionScore == '1' ?  const Color(0xFF048519): shadowColor,
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
                                    color: subProvisionScore != null && subProvisionScore == '0' ? const Color(0xFFFFE8E8): greyColor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: subProvisionScore != null && subProvisionScore == '0' ? Colors.red : shadowColor,
                                    )
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: subProvisionScore != null && subProvisionScore == '0' ? Colors.red : shadowColor,
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
