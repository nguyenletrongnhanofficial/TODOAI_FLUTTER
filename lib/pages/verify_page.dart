import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '/pages/reset_pass_page.dart';

import '../config/config.dart';
import '/modules/profile/services/otp.dart';
import '/pages/login_page.dart';
import '/pages/sign_up_page.dart';

import 'dart:convert';
import '/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '/modules/profile/services/otp.dart';
import '/pages/sign_up_page.dart';
import 'package:http/http.dart';
import '../config/config.dart';

class Verify_Page extends StatefulWidget {
  const Verify_Page({Key? key}) : super(key: key);

  @override
  State<Verify_Page> createState() => _Verify_PageState();
}

class _Verify_PageState extends State<Verify_Page> {
  int _remainingTime = 60; // 60 seconds
  Timer? _timer;
  bool _isButtonDisabled = true;
  String _phoneNumber =
      '+84377712971'; // store the phone number entered in the previous screen

  final TextEditingController _otp1Controller = TextEditingController();
  final TextEditingController _otp2Controller = TextEditingController();
  final TextEditingController _otp3Controller = TextEditingController();
  final TextEditingController _otp4Controller = TextEditingController();
  final TextEditingController _otp5Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  Future<void> _resendOTP() async {
    // make a request to send a new OTP
    // reset the remaining time and start the timer again
    setState(() {
      _remainingTime = 60;
      _startTimer();
    });
  }

  Future<void> _verifyOTP() async {
    final otp =
        '${_otp1Controller.text}${_otp2Controller.text}${_otp3Controller.text}${_otp4Controller.text}${_otp5Controller.text}';
    final success = await OTPService().verifyOTP(_phoneNumber, otp);

    if (success) {
      //

      try {
        Response response =
            await post(Uri.parse("$baseUrl/auth/createUser"), body: {
          'email': nameValue,
          'phone': phoneValue,
          'password': passwordValue,
          'passwordConfirm': passwordConfirmValue,
          'name': nameValue,
        });
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        if (extractedData == null) {
          return;
        }
        print(extractedData["message"]);
        if (response.statusCode == 200) {
          //
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                //title: Text('Hình ảnh'),
                content: Image.asset('assets/images/otp_success.gif'),
                backgroundColor: Colors.transparent,
                actions: [],
              );
            },
          );

          //
          await Future.delayed(const Duration(seconds: 6));
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
          );
        } else {
          print("Failed");
        }
      } catch (e) {
        print(e);
      }

      //Nếu xác thực thành công thì chuyển sang trang tiếp theo
    } else {
      //Nếu xác thực không thành công thì hiển thị thông báo lỗi
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Xác thực không thành công'),
              content: const Text('Mã OTP không đúng, vui lòng nhập lại'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Đồng ý'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mediaHeight = !isLandscape
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 1.2;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, statusBarHeight, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios)),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'LOVISER',
                          style: TextStyle(
                              color: Color(0xFF356899),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: mediaHeight * 0.04),
                        const Text(
                          'Xác minh OTP',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: mediaHeight * 0.04),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: const Text(
                            'Nhập mã xác minh của bạn từ số điện thoại mà chúng tôi đã gửi',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: mediaHeight * 0.02),
                        MediaQuery.of(context).viewInsets.bottom == 0 &&
                                MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                            ? Image(
                                image: AssetImage('assets/images/otp.gif'),
                                width: 170,
                                height: 170)
                            : SizedBox(height: mediaHeight * 0.01),
                        SizedBox(height: mediaHeight * 0.04),
                        Container(
                          height: mediaHeight * 0.1,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: mediaHeight * 0.1,
                                child: TextField(
                                  controller: _otp1Controller,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(1),
                                  ],
                                  textInputAction: TextInputAction.next,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: mediaHeight * 0.1,
                                child: TextField(
                                  controller: _otp2Controller,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(1),
                                  ],
                                  textInputAction: TextInputAction.next,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: mediaHeight * 0.1,
                                child: TextField(
                                  controller: _otp3Controller,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(1),
                                  ],
                                  textInputAction: TextInputAction.next,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: mediaHeight * 0.1,
                                child: TextField(
                                  controller: _otp4Controller,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(1),
                                  ],
                                  textInputAction: TextInputAction.next,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: mediaHeight * 0.1,
                                child: TextField(
                                  controller: _otp5Controller,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(1),
                                  ],
                                  textInputAction: TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: mediaHeight * 0.2,
                        ),
                        //xu ly
                        ElevatedButton(
                          onPressed: () async {
                            //Gửi mã OTP lên server để xác thực
                            _verifyOTP();
                          },
                          child: const Text(
                            'XÁC MINH',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFEC1C24),
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.9,
                                  mediaHeight * 0.07)),
                        ),
                        SizedBox(height: mediaHeight * 0.03),
                        InkWell(
                          onTap: () {
                            //Gửi lại mã OTP
                            OTPService().sendOTP(context, '+84377712971');
                          },
                          child: const Text(
                            'Gửi lại mã OTP',
                            style: TextStyle(
                                color: Color(0xFF356899),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        //Xu ly
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.9,
                        //   height: mediaHeight * 0.08,
                        //   child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //         minimumSize: const Size(213, 50),
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(6.0),
                        //         ),
                        //         primary: const Color(0xFFEC1C24),
                        //         onPrimary: Colors.white),
                        //     child: const FittedBox(
                        //       child: Text(
                        //         'Xác minh',
                        //         style: TextStyle(
                        //           //height: 26,
                        //           color: Colors.white,
                        //           fontSize: 16,
                        //         ),
                        //       ),
                        //     ),
                        //     onPressed: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => ResetPass()),
                        //       );
                        //     },
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
