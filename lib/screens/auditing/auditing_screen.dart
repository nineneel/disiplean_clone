import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/providers/setting_provider.dart';
import 'package:disiplean_clone/screens/auditing/input_audit_screen.dart/input_audit_screen.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuditingScreen extends StatefulWidget {
  const AuditingScreen({
    super.key,
    required this.isChildLocation,
    this.currentLocationId,
  });

  final bool isChildLocation;
  final String? currentLocationId;

  @override
  State<AuditingScreen> createState() => _AuditingScreenState();
}

class _AuditingScreenState extends State<AuditingScreen> {
  Map _allLocationData = {};
  List _allLocationChildKeys = [];
  // List _allLocationParentKeys = [];
  List _allCurrentLocationKeys = [];

  // initial location data
  String? currentLocationName;
  String? currentLocationTag;

  void _getAllLocationData() {
    _allLocationData = Provider.of<SettingProvider>(context, listen: true).settingData['location_setting']?['locations'] ?? {};
    // _allLocationKeys = _allLocationData.keys.toList();

    if (widget.isChildLocation) {
      currentLocationName = _allLocationData[widget.currentLocationId]['name'];
      currentLocationTag = _allLocationData[widget.currentLocationId]['tag'];
      _allLocationChildKeys = _allLocationData[widget.currentLocationId]['child_locations_id'] ?? [];
      for (var locationKey in _allLocationChildKeys) {
        bool addLocation = true; // TODO: use this value: _allLocationData[locationKey]['need_audit'] ?? false;
        if (addLocation) {
          _allCurrentLocationKeys.add(locationKey);
        }
      }
    } else {
      _allCurrentLocationKeys = [];
      _allLocationData.forEach((key, value) {
        bool addLocation = value['parent_location_id'] == null; // TODO: add this value && (value['need_audit'] ?? false);
        if (addLocation) {
          _allCurrentLocationKeys.add(key);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getAllLocationData();
    return ReusableScaffold(
      appBarTitle: widget.isChildLocation ? "Audit Sub Lokasi" : "Audit Lokasi",
      body: Column(
        children: [
          if (widget.isChildLocation)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputAuditScreen(
                        locationId: widget.currentLocationId!,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: greyColor,
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          currentLocationName!,
                          style: lgBoldTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                              color: ligthColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "100",
                              style: smBoldTextStyle,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 28,
                            color: darkColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _allCurrentLocationKeys.length,
              itemBuilder: (context, index) {
                Map locationData = _allLocationData[_allCurrentLocationKeys[index]];
                String locationKey = _allCurrentLocationKeys[index];
                String locationName = locationData['name'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuditingScreen(
                          isChildLocation: true,
                          currentLocationId: locationKey,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 26,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8, right: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: darkColor,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  size: 32,
                                  color: darkColor,
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: greyColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "1/2",
                                    style: smMediumTextStyle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    locationName,
                                    style: mdMediumTextStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: greyColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "100",
                                  style: smBoldTextStyle,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 28,
                                color: darkColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
