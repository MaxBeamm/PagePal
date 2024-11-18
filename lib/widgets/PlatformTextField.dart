import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cis400_final/globals.dart';

class PlatformTextField extends StatelessWidget {

  PlatformTextField({
    super.key,
    this.controller,
    this.hintText,
    this.inputType = null,
    this.requiredReminder = false,
    this.obscureText = false,
  });

  TextEditingController? controller;
  String? hintText;
  bool requiredReminder;
  bool obscureText;
  TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    if (platformIsIOS()) {
      return CupertinoTextField(
        controller: controller,
        placeholder: hintText,
        placeholderStyle: TextStyle(color: requiredReminder ? Colors.red : (isDarkMode(context) ? Colors.white : Colors.black)),
        obscureText: obscureText,
        keyboardType: inputType != null ? inputType : null,
        inputFormatters: inputType != null && inputType! == TextInputType.number ? <TextInputFormatter>[
          // Accepts any number with or without decimal
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[.]{0,1}[0-9]*'))
        ] : <TextInputFormatter>[],
      );
    } else {
      return TextField(
        style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black),
        keyboardType: inputType != null ? inputType : null,
        inputFormatters: inputType != null && inputType! == TextInputType.number ? <TextInputFormatter>[
          // Accepts any number with or without decimal
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[.]{0,1}[0-9]*'))
        ] : <TextInputFormatter>[],
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          //border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          labelText: hintText,
          labelStyle: TextStyle(color: requiredReminder ? Colors.red : (isDarkMode(context) ? Colors.white : Colors.black)),
        ),
      );
    }
  }
}