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
    required this.onPressed,
    this.label,
    this.iconData,
    this.type = ButtonType.primary,
    this.disabled = false,
  });

  final String? label;
  final ButtonType type;
  final IconData? iconData;
  final bool disabled;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(type == ButtonType.small ? 35 : 50),
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
      onPressed: disabled ? null : onPressed,
      child: label == null
          ? Icon(
              iconData,
              color: darkColor,
            )
          : Text(
              label ?? "-",
              style: mdBoldTextStyle.copyWith(
                color: disabled ? shadowColor : darkColor,
                fontSize: type == ButtonType.small ? 12 : null,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }
}
