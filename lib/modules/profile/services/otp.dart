import '/config/config.dart';
import 'package:dio/dio.dart';
import '/pages/verify_page.dart';
import 'package:flutter/material.dart';

class OTPService {
  Future<void> sendOTP(BuildContext context, String phoneNumber) async {
    try {
      final response = await Dio().post(
        '$baseUrl/api/otp/sendOtp',
        data: {'phoneNumber': phoneNumber},
      );

      if (response.statusCode == 200) {
        print('OTP sent');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Verify_Page()),
        );
      } else {
        print('Failed to send OTP');
      }
    } catch (e) {
      print(e.toString());
    }
  }

//Xác thực OTP
  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    try {
      final response = await Dio().post(
        '$baseUrl/api/otp/verifyOtp',
        data: {'phoneNumber': phoneNumber, 'otp': otp},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
