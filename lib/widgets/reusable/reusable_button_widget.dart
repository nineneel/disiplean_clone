import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary,
  small,
}

class ReusableButtonWidget extends StatelessWidget {
  const ReusableButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
  });

  final String label;
  final ButtonType type;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: type == ButtonType.secondary ? backgroundColor : greyColor,
        foregroundColor: darkColor,
        side: BorderSide(
          color: type == ButtonType.secondary ? darkColor : greyColor,
          width: 1,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: mdBoldTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
