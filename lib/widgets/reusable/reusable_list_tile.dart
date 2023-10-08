import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:flutter/material.dart';

class ReusableListTile extends StatelessWidget {
  const ReusableListTile({super.key, required this.title, required this.onTap, this.leading, this.trailing});

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: darkColor,
        ),
      ),
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: lgBoldTextStyle,
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
