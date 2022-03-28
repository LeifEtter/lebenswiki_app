import 'package:flutter/material.dart';

class AuthInputStyling extends StatefulWidget {
  final Color fillColor;
  final bool isError;
  final bool isDeactivated;

  const AuthInputStyling({
    Key? key,
    required TextFormField this.child,
    this.isError = false,
    this.fillColor = Colors.white,
    this.isDeactivated = false,
  }) : super(key: key);

  final TextFormField child;

  @override
  State<AuthInputStyling> createState() => _AuthInputStylingState();
}

class _AuthInputStylingState extends State<AuthInputStyling> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: widget.child,
      decoration: BoxDecoration(
        color: widget.isDeactivated ? Colors.grey : widget.fillColor,
        border: Border.all(
          width: 2.0,
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          widget.isError
              ? BoxShadow(
                  color: Colors.red.withOpacity(1),
                  spreadRadius: 1,
                  blurRadius: 2,
                )
              : BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(1, 2),
                )
        ],
      ),
    );
  }
}

class AuthInputBiography extends StatefulWidget {
  final Color fillColor;

  const AuthInputBiography({
    Key? key,
    required TextFormField this.child,
    this.fillColor = Colors.white,
  }) : super(key: key);

  final TextFormField child;

  @override
  State<AuthInputBiography> createState() => _AuthInputBiographyState();
}

class _AuthInputBiographyState extends State<AuthInputBiography> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
      decoration: BoxDecoration(
        color: widget.fillColor,
        border: Border.all(
          width: 2.0,
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(1, 2),
          ),
        ],
      ),
    );
  }
}
