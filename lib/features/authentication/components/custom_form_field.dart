import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?)? onChanged;
  final String? errorText;
  final IconData iconData;

  const CustomInputField({
    Key? key,
    required this.hintText,
    required this.errorText,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        prefixIcon: Icon(iconData),
      ),
    );
  }
}
