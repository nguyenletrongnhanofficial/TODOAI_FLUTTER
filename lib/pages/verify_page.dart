// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class VerifyPage extends StatefulWidget {
  final String phoneNumber;
  const VerifyPage({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  int _remainingTime = 60; // 60 seconds
  Timer? _timer;

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
    print(widget.phoneNumber);
    print(otp);
    final success = await OTPService().verifyOTP(widget.phoneNumber, otp);

    if (success) {
      //
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Xác thực thành công'),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPass(
                                phoneNumber: widget.phoneNumber,
                              )),
                    );
                  },
                  child: Text('Tiếp tục'))
            ],
          );
        },
      );

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
                  Column(
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
                      SizedBox(
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
                          ? const Image(
                              image: AssetImage('assets/images/otp.gif'),
                              width: 170,
                              height: 170)
                          : SizedBox(height: mediaHeight * 0.01),
                      SizedBox(height: mediaHeight * 0.04),
                      SizedBox(
                        height: mediaHeight * 0.1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: mediaHeight * 0.1,
                              child: TextField(
                                controller: _otp1Controller,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: mediaHeight * 0.1,
                              child: TextField(
                                controller: _otp2Controller,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: mediaHeight * 0.1,
                              child: TextField(
                                controller: _otp3Controller,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: mediaHeight * 0.1,
                              child: TextField(
                                controller: _otp4Controller,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: mediaHeight * 0.1,
                              child: TextField(
                                controller: _otp5Controller,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
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
                      GestureDetector(
                        onTap: () async {
                          //Gửi mã OTP lên server để xác thực
                          _verifyOTP();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFEC1C24),
                              borderRadius: BorderRadius.circular(25)),
                          height: mediaHeight * 0.06,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Center(
                            child: const Text(
                              'XÁC MINH',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
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
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
