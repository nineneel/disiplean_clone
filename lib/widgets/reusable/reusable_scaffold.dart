import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_app_bar.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_button_widget.dart';
import 'package:flutter/material.dart';

class ReusableScaffold extends StatelessWidget {
  const ReusableScaffold({
    super.key,
    required this.appBarTitle,
    required this.body,
    this.buttonBottomSheet,
    this.color,
  });

  final String appBarTitle;
  final bool? color;
  final Widget body;
  final ReusableButtonWidget? buttonBottomSheet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(title: appBarTitle),
      body: body,
      bottomSheet: buttonBottomSheet != null
          ? Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: darkColor,
                    blurRadius: 2.0,
                    offset: const Offset(0.0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 12,
              ),
              child: buttonBottomSheet,
            )
          : null,
    );
  }
}
