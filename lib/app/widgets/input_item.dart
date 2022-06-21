import 'package:d2ypresence/app/common/styles.dart';
import 'package:flutter/material.dart';

Widget inputItem(
  BuildContext context,
  String name,
  TextEditingController controller,
  bool obsecureText,
  Widget suffixIcon,
) {
  return Container(
    color: Colors.white,
    // width: MediaQuery.of(context).size.width - 50,
    height: 50,
    child: TextFormField(
      controller: controller,
      obscureText: obsecureText,
      style: const TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: name,
        labelStyle: const TextStyle(
          fontSize: 16,
        ),
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 1.5,
            color: primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
    ),
  );
}
