import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:flutter/material.dart';

class ReusableSnackBar {
  static show(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: accentColor,
        content: Text(
          text,
          style: mdBoldTextStyle.copyWith(color: ligthColor),
        ),
      ),
    );
  }
}
