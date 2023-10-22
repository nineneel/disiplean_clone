import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:flutter/material.dart';

enum ListTileType {
  primary,
  secondary,
}

enum ListTileBackground {
  dark,
  light,
}

enum ListTileFontSize {
  sm,
  md,
  lg,
}

class ReusableListTile extends StatelessWidget {
  const ReusableListTile({
    super.key,
    required this.title,
    this.onTap,
    this.leading,
    this.trailing,
    this.underline = false,
    this.type = ListTileType.primary,
    this.fontSizeType,
    this.titleFontWeight,
    this.backgroundType,
    this.height = 60,
    this.titleColor,
    this.textOverflow,
  });

  final String title;
  final double height;
  final Widget? leading;
  final Widget? trailing;
  final Function()? onTap;
  final Color? titleColor;
  final FontWeight? titleFontWeight;
  final bool underline;
  final ListTileType type;
  final ListTileFontSize? fontSizeType;
  final ListTileBackground? backgroundType;
  final TextOverflow? textOverflow;

  TextStyle getTitleTextStyle() {
    TextStyle titleTextStyle = fontSizeType == ListTileFontSize.sm
        ? smBoldTextStyle
        : fontSizeType == ListTileFontSize.md
            ? mdBoldTextStyle
            : lgBoldTextStyle;

    return titleTextStyle.copyWith(
      color: titleColor ?? darkColor,
      fontWeight: titleFontWeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: underline ? null : BorderRadius.circular(8),
        color: backgroundType == ListTileBackground.dark ? greyColor : Colors.transparent,
        border: underline
            ? Border(
                bottom: BorderSide(
                  width: 1,
                  color: darkColor,
                ),
              )
            : backgroundType == ListTileBackground.dark || type == ListTileType.secondary
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
            overflow: textOverflow,
            style: getTitleTextStyle(),
          ),
          dense: true,
          visualDensity: VisualDensity(vertical: height >= 60 ? 0 : -4),
          trailing: trailing,
          contentPadding: type == ListTileType.secondary ? const EdgeInsets.all(0) : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
