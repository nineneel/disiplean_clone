import 'package:disiplean_clone/constants/style/color.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:flutter/material.dart';

class ReusableTextInputWidget extends StatelessWidget {
  const ReusableTextInputWidget({
    super.key,
    required this.label,
    required this.keyboardType,
    required this.controller,
    this.validator,
  });
  
  final String label;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: mdBoldTextStyle),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: keyboardType == TextInputType.visiblePassword ? true : false,
          cursorColor: darkColor, 
          decoration: InputDecoration(
            isDense: true,
            contentPadding:const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            labelText: "Masukkan $label",
            labelStyle: mdNormalTextStyle,
            focusColor: greyColor,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: darkColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // onEditingComplete: () => _focusNodePassword.requestFocus(),
          validator: validator,
        ),
      ],
    );
  }
}
