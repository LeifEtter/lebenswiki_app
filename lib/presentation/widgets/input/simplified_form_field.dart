import 'package:flutter/material.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';

class SimplifiedFormField extends StatelessWidget {
  final Function? onChanged;
  final TextEditingController controller;
  final String? labelText;
  final String? errorText;
  final String? hintText;
  final Color? hintColor;
  final double? borderRadius;
  final Color? color;
  final int minLines;
  final int maxLines;
  final String? helperText;
  final int? maxLength;

  const SimplifiedFormField({
    Key? key,
    required this.controller,
    this.labelText,
    this.onChanged,
    this.errorText,
    this.hintText,
    this.hintColor,
    this.borderRadius,
    this.color,
    this.minLines = 1,
    this.maxLines = 1,
    this.helperText,
    this.maxLength,
  }) : super(key: key);

  const SimplifiedFormField.multiline({
    Key? key,
    required this.controller,
    this.labelText,
    this.onChanged,
    this.errorText,
    this.hintText,
    this.hintColor,
    this.borderRadius,
    this.color,
    required this.minLines,
    required this.maxLines,
    this.helperText,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 2),
            child: Text(
              labelText ?? "",
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16),
            ),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            maxLength: maxLength,
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
            onChanged: (String newValue) => onChanged?.call(newValue),
            decoration: InputDecoration(
              helperText: helperText,
              fillColor: color ?? Colors.white,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 0),
                borderSide: BorderSide(color: CustomColors.darkGrey, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 0),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0),
              ),
              errorText: errorText,
              contentPadding: const EdgeInsets.all(15.0),
              hintText: hintText,
              focusedErrorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius ?? 0),
                    topRight: Radius.circular(borderRadius ?? 0),
                  ),
                  borderSide: const BorderSide(width: 2, color: Colors.red)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 0),
                  borderSide: const BorderSide(width: 1, color: Colors.red)),
              hintStyle: TextStyle(
                color: hintColor ?? CustomColors.mediumGrey,
              ),
            ),
          ),
        ],
      );
}
