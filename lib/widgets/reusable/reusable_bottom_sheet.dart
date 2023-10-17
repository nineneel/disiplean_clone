import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_button_widget.dart';
import 'package:flutter/material.dart';

class ReusableBottomSheet {
  static buildModalBottom({
    required BuildContext context,
    Widget? child,
    String? title,
    String? desc,
    String? primaryButtonLabel,
    String? secondaryButtonLabel,
    Function()? primaryButtonOnPress,
    Function()? secondaryButtonOnPress,
    Function()? whenComplete,
    bool isControlledValue = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 26),
              // padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  if (title != null) Text(title, style: lgBoldTextStyle),
                  if (title != null) const SizedBox(height: 26),

                  // Desc
                  if (desc != null)
                    Text(
                      desc,
                      style: lgMediumTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  if (desc != null) const SizedBox(height: 24),

                  // Child
                  if (child != null) child,
                  // Flexible(child: child),
                  // Expanded(child: ListView.builder(itemCount: 120, shrinkWrap: true, itemBuilder: (context, index) => Text(index.toString()))),

                  // Primary Button
                  if (primaryButtonLabel != null) const SizedBox(height: 24),
                  if (primaryButtonLabel != null)
                    ReusableButtonWidget(
                      label: primaryButtonLabel,
                      onPressed: primaryButtonOnPress ?? () {},
                    ),

                  // Secondary Button
                  if (secondaryButtonLabel != null) const SizedBox(height: 12),
                  if (secondaryButtonLabel != null)
                    ReusableButtonWidget(
                      label: secondaryButtonLabel,
                      type: ButtonType.secondary,
                      onPressed: secondaryButtonOnPress ?? () {},
                    ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(whenComplete ?? () {});
  }
}
