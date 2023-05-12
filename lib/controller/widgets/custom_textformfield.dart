import 'package:flutter/material.dart';
import '../const.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final dynamic height;

  const CustomTextField({
    super.key,
    required this.size,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    required this.validator,
    required this.height,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Container(
        height: size.height * height,
        decoration: BoxDecoration(
            border: Border.all(color: blackColor),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return validator(value);
            },
          ),
        ),
      ),
    );
  }
}
