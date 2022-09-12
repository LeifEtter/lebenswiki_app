import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?)? onChanged;
  final String? errorText;
  final Icon? icon;
  final bool? enabled;
  final double paddingTop;
  final bool isPassword;
  final String? initialValue;
  final bool isMultiline;
  final bool hasShadow;
  final double borderRadius;
  final Color backgroundColor;

  const CustomInputField({
    Key? key,
    required this.hintText,
    required this.errorText,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.icon,
    this.enabled = true,
    this.paddingTop = 0,
    this.isPassword = false,
    this.initialValue,
    this.isMultiline = false,
    this.hasShadow = true,
    this.borderRadius = 15.0,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool obscure = false;

  @override
  void initState() {
    super.initState();
    if (widget.isPassword) obscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.paddingTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customFormFieldStyling(
              borderRadius: widget.borderRadius,
              backgroundColor: widget.backgroundColor,
              hasShadow: widget.hasShadow,
              child: !widget.isMultiline
                  ? TextFormField(
                      initialValue: widget.initialValue ?? "",
                      obscureText: obscure,
                      onChanged: widget.onChanged,
                      validator: widget.validator,
                      inputFormatters: widget.inputFormatters,
                      enabled: widget.enabled,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 15, top: 0),
                        hintText: widget.hintText,
                        prefixIcon: widget.icon,
                        suffixIcon: widget.isPassword
                            ? IconButton(
                                icon: Icon(obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () => setState(() {
                                      obscure = !obscure;
                                    }))
                            : null,
                        border: InputBorder.none,
                      ),
                    )
                  : TextFormField(
                      minLines: 3,
                      maxLines: 5,
                      initialValue: widget.initialValue ?? "",
                      onChanged: widget.onChanged,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        hintText: widget.hintText,
                        prefixIcon: widget.icon,
                        border: InputBorder.none,
                      ),
                    )),
          widget.errorText != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Text(
                    widget.errorText!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

Widget customFormFieldStyling({
  required Widget child,
  required double borderRadius,
  required Color backgroundColor,
  required bool hasShadow,
}) {
  return PhysicalModel(
    color: backgroundColor,
    elevation: hasShadow ? 3.0 : 0,
    child: child,
    borderRadius: BorderRadius.circular(borderRadius),
  );
}
