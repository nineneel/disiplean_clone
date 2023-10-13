import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/providers/setting_provider.dart';
import 'package:disiplean_clone/providers/user_provider.dart';
import 'package:disiplean_clone/screens/profile/profile_screen.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future(() {
      Provider.of<UserProvider>(context, listen: false).setUserData();
      Provider.of<SettingProvider>(context, listen: false).setSettingData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 26, vertical: 26),
        child: ReusableBoxWidget(
          title: "Action Bar",
          child: Text(
            "Tidak ada aksi yang perlu dilakukan!",
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
