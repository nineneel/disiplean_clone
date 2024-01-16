import 'dart:async';
import 'package:disiplean_clone/screens/auditing/select_audit_date.dart';
import 'package:disiplean_clone/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreenTicket extends StatefulWidget {
  static const id = 'splash_screen_page';

  const SplashScreenTicket({
    Key? key,
    required this.splashGif,
    required this.splashText,
    this.title,
    this.source,
    this.ticketId,
  }) : super(key: key);

  final String? ticketId;
  final String? title;
  final String splashGif;
  final String splashText;
  final String? source;

  @override
  State<SplashScreenTicket> createState() => _SplashScreenTicketState();
}

class _SplashScreenTicketState extends State<SplashScreenTicket> {
  late AssetImage checkGif;

  @override
  void initState() {
    checkGif = AssetImage(widget.splashGif);
    Timer(const Duration(milliseconds: 2200), () async {
      ///checking if source from login
      if (widget.source != null) {
        if (widget.source == 'audit') {
          //todo: changes MULTIPLE PROFILES
          // if(Provider.of<UserDataProvider>(context, listen: false).userData['organization_list']!=null) {
          //   Navigator.pushNamed(context, HomePage.id);
          // } else {
          //   Navigator.pushNamed(context, FreeUserPage.id);
          // }
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectDateAudit()));
        }
      }
    });
  }

  @override
  void dispose() {
    checkGif.evict();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Check Gif
            Center(
              child: Image(
                image: checkGif,
                height: 250,
                width: 250,
              ),
            ),

            const SizedBox(height: 10),
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Center(
                  child: Text(
                    widget.title ?? 'title',
                    style: const TextStyle(
                      fontSize: 32, color: Colors.green
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Text(
                  widget.splashText,
                  style: const TextStyle(
                    fontSize: 18
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
