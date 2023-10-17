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
import 'package:provider/provider.dart';

class LocationSettingScreen extends StatefulWidget {
  const LocationSettingScreen({
    super.key,
    required this.isChildLocation,
    this.currentLocationId,
  });

  final bool isChildLocation;
  final String? currentLocationId;

  @override
  State<LocationSettingScreen> createState() => _LocationSettingScreenState();
}

class _LocationSettingScreenState extends State<LocationSettingScreen> {
  // Controller
  final TextEditingController _locationNameController = TextEditingController(text: "");
  // initial data
  Map _allLocationData = {};
  // List _allLocationKeys = [];
  List _allLocationParentKeys = [];
  List _allLocationChildKeys = [];

  // initial location data
  String? currentLocationName;
  String? currentLocationTag;

  void _getAllLocationData() {
    _allLocationData = Provider.of<SettingProvider>(context, listen: true).settingData['location_setting']?['locations'] ?? {};
    // _allLocationKeys = _allLocationData.keys.toList();

    if (widget.isChildLocation) {
      _allLocationChildKeys = _allLocationData[widget.currentLocationId]['child_locations_id'] ?? [];
      currentLocationName = _allLocationData[widget.currentLocationId]['name'];
      currentLocationTag = _allLocationData[widget.currentLocationId]['tag'];
    } else {
      _allLocationParentKeys = [];
      _allLocationData.forEach((key, value) {
        if (value['parent_location_id'] == null) {
          _allLocationParentKeys.add(key);
        }
      });
    }
  }

  void _showAddLocationBottomSheet() {
    // Create function to save new provision
    void saveAuditSubProvision() async {
      Map response = await SettingDatabase.saveLocation(
        userKey: Provider.of<UserProvider>(context, listen: false).userData['key'],
        locationName: _locationNameController.text,
        isChildLocation: widget.isChildLocation,
        parentLocationId: widget.currentLocationId,
        totalParentChildLocations: _allLocationChildKeys.length,
      );

      if (context.mounted) {
        if (response['success']) {
          // reset input data
          _locationNameController.text = "";

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
      title:  widget.isChildLocation ? "Tambahkan Sub Lokasi" : "Tambahkan Lokasi",
      child: Column(
        children: [
          ReusableTextInputWidget(
            label: "Nama",
            keyboardType: TextInputType.text,
            controller: _locationNameController,
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _locationNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _getAllLocationData();
    return ReusableScaffold(
      appBarTitle: widget.isChildLocation ? "Detail Lokasi" : "Pengaturan Lokasi",
      body: Padding(
        padding: const EdgeInsets.fromLTRB(26, 26, 26, 92),
        child: Column(
          children: [
            if (widget.isChildLocation)
              ReusableBoxWidget(
                title: "Detail Lokasi",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentLocationName ?? "-",
                      style: largeTextStyle,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      currentLocationTag ?? "-",
                      style: mdMediumTextStyle,
                    )
                  ],
                ),
              ),
            if (widget.isChildLocation) const SizedBox(height: 24),
            Flexible(
              child: ReusableBoxWidget(
                title: widget.isChildLocation ? "Sub Lokasi" : "Lokasi",
                child: Flexible(
                  child: widget.isChildLocation
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: _allLocationChildKeys.length,
                          itemBuilder: (context, index) {
                            Map subLocationData = _allLocationData[_allLocationChildKeys[index]];
                            String subLocationKey = _allLocationChildKeys[index];
                            String subLocationName = subLocationData['name'];
                            // String subLocationTag = subLocationData['tag'];
                            return ReusableListTile(
                              title: subLocationName,
                              height: 50,
                              type: ListTileType.secondary,
                              fontSizeType: ListTileFontSize.md,
                              titleFontWeight: FontWeight.w500,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LocationSettingScreen(
                                      isChildLocation: true,
                                      currentLocationId: subLocationKey,
                                    ),
                                  ),
                                );
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => LocationSettingScreen(isChildLocation: true)));
                              },
                              leading: Icon(
                                Icons.location_on_outlined,
                                size: 36,
                                color: darkColor,
                              ),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 28,
                                color: darkColor,
                              ),
                            );
                          },
                        )
                      : _allLocationParentKeys.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _allLocationParentKeys.length,
                              itemBuilder: (context, index) {
                                Map locationData = _allLocationData[_allLocationParentKeys[index]];
                                String locationKey = _allLocationParentKeys[index];
                                String locationName = locationData['name'];
                                return ReusableListTile(
                                  title: locationName,
                                  height: 50,
                                  type: ListTileType.secondary,
                                  fontSizeType: ListTileFontSize.md,
                                  titleFontWeight: FontWeight.w500,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LocationSettingScreen(
                                          isChildLocation: true,
                                          currentLocationId: locationKey,
                                        ),
                                      ),
                                    );
                                  },
                                  leading: Icon(
                                    Icons.location_on_outlined,
                                    size: 36,
                                    color: darkColor,
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right_rounded,
                                    size: 28,
                                    color: darkColor,
                                  ),
                                );
                              },
                            )
                          : Text(
                              "Tidak ada lokasi!",
                              style: mdBoldTextStyle,
                              textAlign: TextAlign.center,
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
      buttonBottomSheet: ReusableButtonWidget(
        label: widget.isChildLocation ? "Tambahkan Sub Lokasi" : "Tambahkan Lokasi",
        type: ButtonType.primary,
        onPressed: _showAddLocationBottomSheet,
      ),
    );
  }
}
