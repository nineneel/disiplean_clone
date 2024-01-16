import 'package:disiplean_clone/providers/action_bar_provider.dart';
import 'package:disiplean_clone/providers/setting_provider.dart';
import 'package:disiplean_clone/providers/user_provider.dart';
import 'package:disiplean_clone/screens/auth/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..indicatorSize = 30.0
    ..radius = 4.0
    ..userInteractions = false
    ..dismissOnTap = true;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => SettingProvider()),
        ChangeNotifierProvider(create: (context) => ActionBarProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Disiplean Clone",
        home: const LandingScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
