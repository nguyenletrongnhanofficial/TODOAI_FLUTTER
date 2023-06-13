import 'package:flutter/material.dart';

class PhoneNumberTextField extends StatelessWidget {
  final TextEditingController controller;

  PhoneNumberTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xfff7f8f9),
          hintText: 'Số điện thoại',
          hintStyle: const TextStyle(
            fontFamily: 'AvertaStdCY-Regular',
            color: Color(0xff616161),
          ),
          prefixIcon: Image.asset('assets/images/phone_icon.png'),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25), //<-- ADD THIS
          ),
        ),
        style: const TextStyle(
          fontFamily: 'AvertaStdCY-Regular',
          color: Colors.black,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Hãy điền số điện thoại!";
          } else {
            return null;
          }
        });
  }
}
