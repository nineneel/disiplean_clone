import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:flutter/material.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReusableAppBar({super.key, required this.title, this.height = 64});

  final String title;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: greyColor,
      foregroundColor: darkColor,
      elevation: 0,
      toolbarHeight: 64,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left_rounded,
          size: 36,
          color: darkColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: largeTextStyle,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}
