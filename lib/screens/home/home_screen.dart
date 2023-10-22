import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/providers/action_bar_provider.dart';
import 'package:disiplean_clone/providers/setting_provider.dart';
import 'package:disiplean_clone/providers/user_provider.dart';
import 'package:disiplean_clone/screens/auditing/auditing_screen.dart';
import 'package:disiplean_clone/screens/profile/profile_screen.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_box_widget.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map _actionBarWidgets = {};

  void _getActionBarData() async {
    // get action bar
    _actionBarWidgets = Provider.of<ActionBarProvider>(context, listen: true).actionBarWidgets;
  }

  @override
  void initState() {
    Future(() {
      // Set all provider
      Provider.of<UserProvider>(context, listen: false).setUserData();
      Provider.of<UserProvider>(context, listen: false).setAllUserData();
      Provider.of<UserProvider>(context, listen: false).setAuditorInvitationData(context);
      Provider.of<SettingProvider>(context, listen: false).setSettingData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getActionBarData();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: greyColor,
        foregroundColor: darkColor,
        title: Text("Disiplean Clone", style: largeTextStyle),
        elevation: 0,
        toolbarHeight: 64,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
            icon: Icon(
              Icons.account_circle_rounded,
              size: 35,
              color: darkColor,
            ),
            splashRadius: 25,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
        child: ReusableBoxWidget(
            title: "Action Bar",
            child: Column(
              children: [
                _actionBarWidgets.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: _actionBarWidgets.length,
                        itemBuilder: (context, index) => _actionBarWidgets[_actionBarWidgets.keys.toList()[index]],
                      )
                    : Text(
                        "Tidak ada aksi yang perlu dilakukan!",
                        textAlign: TextAlign.left,
                        style: mdBoldTextStyle,
                      ),
                const SizedBox(height: 10),
                ReusableButtonWidget(
                  label: "Test auditing",
                  type: ButtonType.small,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AuditingScreen(isChildLocation: false)));
                  },
                ),
              ],
            )),
      ),
    );
  }
}
