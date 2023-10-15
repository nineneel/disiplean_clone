import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_list_tile.dart';
import 'package:flutter/widgets.dart';

class ReusableActionBar extends StatelessWidget {
  const ReusableActionBar({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ReusableListTile(
        title: label,
        fontSizeType: ListTileFontSize.md,
        height: 40,
        trailing: Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: accentColor,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
