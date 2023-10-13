import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:flutter/material.dart';

enum ListTileBackgroundType {
  dark,
  light,
}

class ReusableListTile extends StatelessWidget {
  const ReusableListTile({
    super.key,
    required this.title,
    required this.onTap,
    this.leading,
    this.trailing,
    this.backgroundType,
    this.height = 60,
  });

  final String title;
  final double height;
  final Widget? leading;
  final Widget? trailing;
  final Function() onTap;
  final ListTileBackgroundType? backgroundType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundType == ListTileBackgroundType.dark ? greyColor : backgroundColor,
        border: backgroundType == ListTileBackgroundType.dark
            ? null
            : Border.all(
                width: 1,
                color: darkColor,
              ),
      ),
      child: Center(
        child: ListTile(
          leading: leading,
          title: Text(
            title,
            style: lgBoldTextStyle,
          ),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
