import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:flutter/material.dart';

class ReusableSnackBar {
  static show(BuildContext context, String text, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isSuccess ? accentColor : errorColor,
        // behavior: SnackBarBehavior.floating,
        content: Text(
          text,
          style: mdBoldTextStyle.copyWith(color: ligthColor),
        ),
      ),
    );
  }
}
