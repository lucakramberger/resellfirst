import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RFTextField extends StatefulWidget {
  RFTextField(
      {Key? key,
      this.icon,
      required this.text,
      required this.maxLength,
      this.enabled = true,
      required this.textInputType,
      required this.controller,
      this.suffixIcon,
      required this.maxlines,
      this.onChanged,
      this.onFieldSubmit})
      : super(key: key);

  Icon? icon;
  final String text;
  final int maxLength;
  final bool enabled;
  final TextInputType textInputType;
  final void Function(String)? onFieldSubmit;
  Icon? suffixIcon;
  final TextEditingController controller;
  // ignore: prefer_typing_uninitialized_variables
  final maxlines;
  void Function(String)? onChanged;

  @override
  _RFTextFieldState createState() => _RFTextFieldState();
}

class _RFTextFieldState extends State<RFTextField> {
  late bool _isObscure = false;

  @override
  void initState() {
    super.initState();
    if (widget.suffixIcon != null) {
      _isObscure = true;
    } else {
      _isObscure = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextField(
        onChanged: widget.onChanged,
        keyboardType: widget.textInputType,
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(context).textTheme.bodyText1,
        cursorColor: Colors.grey,
        obscureText: _isObscure,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          filled: true,
          fillColor: Colors.grey[200], //Theme.of(context).canvasColor,
          focusColor: Colors.lightBlue,
          hoverColor: Colors.lightBlue,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none),
          isDense: true,
          hintText: widget.text,
          prefixIcon: widget.icon,
          counterText: '',
        ),
        maxLength: widget.maxLength,
        maxLines: widget.maxlines,
        enabled: widget.enabled,
        controller: widget.controller,
      ),
    );
  }
}
