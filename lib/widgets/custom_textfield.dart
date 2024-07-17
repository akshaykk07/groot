import 'package:flutter/material.dart';

import '../const/color.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    // custom TextField........
    super.key,
    required this.hint,
    this.kebordtype = TextInputType.text,
    required this.controller,
    required this.validator,
    this.obscure = false,
    this.fillcolor = white,
    this.readonly = false,
    this.onChanged,
    this.txtStyle = whiteone,
    this.cursorcolor = whiteone,
  });

  final String hint;
  final TextInputType kebordtype;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscure;
  final bool readonly;
  final Color fillcolor;
  final Color txtStyle;
  final Color cursorcolor;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: TextFormField(
        cursorColor: cursorcolor,
        keyboardType: kebordtype,
        controller: controller,
        validator: validator,
        obscureText: obscure,
        readOnly: readonly,
        onChanged: onChanged,
        style: TextStyle(color: txtStyle),
        decoration: InputDecoration(
            fillColor: fillcolor,
            filled: true,
            label: Text(hint),
            labelStyle: const TextStyle(color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: customBlack1),
                borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: customBlack1),
                borderRadius: BorderRadius.circular(8)),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: customBlack2))),
      ),
    );
  }
}

class CustomTextField2 extends StatelessWidget {
  const CustomTextField2({
    // custom TextField........
    super.key,
    required this.hint,
    this.kebordtype = TextInputType.text,
    required this.controller,
    required this.validator,
    this.obscure = false,
    this.fillcolor = customBlack2,
    this.readonly = false,
    this.onChanged,
    this.prefix = true,
    required this.icon,
    this.iconclor = whiteone,
    this.cursorcolr = whiteone,
    this.txtcolor = whiteone,
  });

  final String hint;
  final TextInputType kebordtype;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscure;
  final bool readonly;
  final Color fillcolor;
  final Function(String)? onChanged;
  final bool prefix;
  final IconData icon;
  final Color iconclor;
  final Color cursorcolr;
  final Color txtcolor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: TextFormField(
        cursorColor: cursorcolr,
        keyboardType: kebordtype,
        controller: controller,
        validator: validator,
        obscureText: obscure,
        readOnly: readonly,
        onChanged: onChanged,
        style: TextStyle(color: txtcolor),
        decoration: InputDecoration(
            prefixIcon: prefix == true
                ? Icon(
                    icon,
                    color: iconclor,
                  )
                : const SizedBox(),
            fillColor: fillcolor,
            filled: true,
            hintText: hint,
            hintStyle:
                const TextStyle(color: whiteone, fontWeight: FontWeight.w300),
            labelStyle: const TextStyle(color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: customBlack1),
                borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: customBlack1),
                borderRadius: BorderRadius.circular(8)),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: customBlack2))),
      ),
    );
  }
}
