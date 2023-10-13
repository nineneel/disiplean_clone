import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/widgets/reusable/reusable_button_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ReusableBottomSheet {
  static buildModalBottom({
    required BuildContext context,
    required Widget child,
    String? title,
    String? desc,
    String? primaryButtonLabel,
    String? secondaryButtonLabel,
    Function()? primaryButtonOnPress,
    Function()? secondaryButtonOnPress,
    bool isControlledValue = false,
  }) {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 26),
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    // Title
                    if (title != null) Text(title, style: lgBoldTextStyle),
                    if (title != null) const SizedBox(height: 26),

                    // Desc
                    if (desc != null) Text(desc, style: lgMediumTextStyle),
                    if (desc != null) const SizedBox(height: 24),

                    // Child
                    child,

                    // Primary Button
                    if (primaryButtonLabel != null) const SizedBox(height: 24),
                    if (primaryButtonLabel != null)
                      ReusableButtonWidget(
                        label: "Primary",
                        onPressed: primaryButtonOnPress ?? () {},
                      ),
                    if (primaryButtonLabel != null) const SizedBox(height: 12),

                    // Secondary Button
                    if (secondaryButtonLabel != null)
                      ReusableButtonWidget(
                        label: "Primary",
                        onPressed: secondaryButtonOnPress ?? () {},
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
