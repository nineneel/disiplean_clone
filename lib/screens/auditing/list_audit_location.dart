import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/databases/audit_database.dart';
import 'package:disiplean_clone/providers/setting_provider.dart';
import 'package:disiplean_clone/screens/auditing/filter_bottom_sheet.dart';
import 'package:disiplean_clone/screens/auditing/input_audit_screen.dart/input_audit_screen.dart';
import 'package:disiplean_clone/screens/auditing/input_audit_screen_new.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ListAuditLocation extends StatefulWidget {
  const ListAuditLocation({
    super.key,
    required this.isChildLocation,
    this.currentLocationId,
    this.locationImage,
  });

  final bool isChildLocation;
  final String? currentLocationId;
  final String? locationImage;

  @override
  State<ListAuditLocation> createState() => _ListAuditLocationState();
}

class _ListAuditLocationState extends State<ListAuditLocation> {
  Map _allLocationData = {};
  List _allLocationChildKeys = [];
  // List _allLocationParentKeys = [];
  List _allCurrentLocationKeys = [];
  Map<String, int?> locationScore = {};
  int? score;
  // initial location data
  String? currentLocationName;
  String? currentLocationTag;
  String searchText = '';
  String resultFilter = 'Semua';

  void _getAllLocationData() {
    _allLocationData = Provider.of<SettingProvider>(context, listen: true).settingData['location_setting']?['locations'] ?? {};
    _allCurrentLocationKeys.clear();
    if (widget.isChildLocation) {
      currentLocationName = _allLocationData[widget.currentLocationId]['name'];
      currentLocationTag = _allLocationData[widget.currentLocationId]['tag'];
      _allLocationChildKeys = _allLocationData[widget.currentLocationId]['child_locations_id'] ?? [];
      for (var locationKey in _allLocationChildKeys) {
        bool addLocation = true;
        if (addLocation) {
          _allCurrentLocationKeys.add(locationKey);
        }
      }
    } else {
      _allCurrentLocationKeys = [];
      _allLocationData.forEach((key, value) {
        bool addLocation = value['parent_location_id'] == null;
        if (addLocation) {
          _allCurrentLocationKeys.add(key);
        }
      });
    }
  }

  void loadAuditScoreLocation() async {
    String yearMonth = "${DateTime.now().year}_${DateTime.now().month}";
    Map<String, int?> updatedLocationScore = {};
    for (String locationId in _allCurrentLocationKeys) {
      Map<String, int> locationScores = await AuditDatabase.getScoreAuditResultsForMonth(yearMonth: yearMonth, locationID: locationId);
      if (locationScores.containsKey(locationId)) {
        int score = locationScores[locationId]!;
        updatedLocationScore[locationId] = score;
      }
    }
    setState(() {
      locationScore = updatedLocationScore;
    });
  }

  @override
  void initState() {
    Future(() async {
      loadAuditScoreLocation();
    });
    print('score location = $locationScore');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getAllLocationData();
    int? locationParentScore = locationScore[widget.currentLocationId];
    return ReusableScaffold(
      appBarTitle: widget.isChildLocation ? "Audit Sub Lokasi" : "Audit Lokasi",
      body: Column(
        children: [
          if (widget.isChildLocation)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.push<double?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputAuditScreenNew(
                        locationId: widget.currentLocationId!,
                        locationImage: widget.locationImage!,
                        locationName: currentLocationName!,
                      ),
                    ),
                  ).then((double? updatedScore) {
                    if (updatedScore != null) {
                      setState(() {
                        locationParentScore;
                        locationScore[_allCurrentLocationKeys];
                      });
                    }
                  });
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
                          locationParentScore != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: ligthColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    locationParentScore!.toString(),
                                    style: smBoldTextStyle,
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: ligthColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Belum dinilai',
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

          /// Widgets for search and filter options.
          Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 15, left: 25, right: 25),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF0F4F7),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 12,
                            ),
                            child: Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchText = value.toLowerCase();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                    onTap: () async {
                      // Show filter options in a bottom sheet using FilterBottomSheet
                      resultFilter = (await FilterBottomSheet.showFilterBottomSheet(
                            context: context,
                            onSelectFilter: (filter) {
                              setState(() {
                                resultFilter = filter;
                              });
                            },
                            selectedFilter: resultFilter,
                          )) ??
                          '';
                      setState(() {});
                    },
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_list, size: 20),
                        SizedBox(width: 5),
                        Text('Filter'),
                      ],
                    )),
              ],
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
                int? scoreLocationIndex = locationScore[_allCurrentLocationKeys[index]];
                print('scoreee = $scoreLocationIndex');
                bool showFilterResult = true;
                if (resultFilter == 'Sudah diaudit') {
                  showFilterResult = scoreLocationIndex != null;
                } else if (resultFilter == 'Belum diaudit') {
                  showFilterResult = scoreLocationIndex == null;
                }
                if (locationName.toLowerCase().contains(searchText)) {
                  return showFilterResult || resultFilter == 'Semua'
                      ? GestureDetector(
                          onTap: () {
                            if (scoreLocationIndex == null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListAuditLocation(
                                    isChildLocation: true,
                                    currentLocationId: locationKey,
                                    locationImage: locationData['picture_url'],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 20,
                            ),
                            child: Card(
                              color: scoreLocationIndex == null ? const Color(0xFF6D9773) : Colors.grey,
                              elevation: 2, // Add elevation for a card-like appearance
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        child: locationData['picture_url'] != null
                                            ? scoreLocationIndex == null
                                                ? AspectRatio(
                                                    aspectRatio: 16 / 9,
                                                    child: Image.network(
                                                      locationData['picture_url'],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : AspectRatio(
                                                    aspectRatio: 16 / 9,
                                                    child: ColorFiltered(
                                                      colorFilter: const ColorFilter.mode(
                                                        Colors.grey,
                                                        BlendMode.saturation,
                                                      ),
                                                      child: Image.network(
                                                        locationData['picture_url'],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                            : Container(
                                                height: 150,
                                                color: Colors.white,
                                                child: const Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.image_not_supported,
                                                      size: 48,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'No Image',
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            locationName,
                                            style: mdMediumTextStyle.copyWith(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(
                                        //     vertical: 4,
                                        //     horizontal: 6,
                                        //   ),
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.white,
                                        //     borderRadius: BorderRadius.circular(6),
                                        //   ),
                                        //   child: Text(
                                        //     "1/2", // You may replace this with your actual score logic
                                        //     style: smMediumTextStyle.copyWith(fontSize: 14),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              children: [
                                                scoreLocationIndex != null
                                                    ? Container(
                                                        padding: const EdgeInsets.symmetric(
                                                          vertical: 4,
                                                          horizontal: 6,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: Text(
                                                          "$scoreLocationIndex", // Display the actual score
                                                          style: smMediumTextStyle.copyWith(fontSize: 14, color: Colors.white),
                                                        ),
                                                      )
                                                    : Container(
                                                        padding: const EdgeInsets.symmetric(
                                                          vertical: 4,
                                                          horizontal: 6,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: Text(
                                                          "Belum dinilai",
                                                          style: smMediumTextStyle.copyWith(fontSize: 14),
                                                        ),
                                                      )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            size: 28,
                                            color: darkColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
