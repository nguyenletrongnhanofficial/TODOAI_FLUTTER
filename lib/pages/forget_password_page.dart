import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/pages/verify_page.dart';
import '../modules/profile/services/otp.dart';
import '../pages/login_page.dart';
import '../widgets/phone_input_field/phone_input_field.dart';

class Forget_pass extends StatefulWidget {
  const Forget_pass({Key? key}) : super(key: key);

  @override
  State<Forget_pass> createState() => _Forget_passState();
}

class _Forget_passState extends State<Forget_pass>
    with SingleTickerProviderStateMixin {
  TextEditingController phoneInputField = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mediaHeight = !isLandscape
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;

    // handle status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //color set to transperent or set your own color
      statusBarIconBrightness: Brightness.dark,
      //set brightness for icons, like dark background light icons
    ));

    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, statusBarHeight, 0, 0),
                child: Column(
                  children: <Widget>[
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
                    const Text(
                      'LOVISER',
                      style: TextStyle(
                          color: Color(0xFF356899),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: mediaHeight * 0.04),
                    const Text(
                      'Quên mật khẩu',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: mediaHeight * 0.04),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: const Text(
                        'Nhập email hoặc số điện thoại của bạn, chúng tôi sẽ gửi cho bạn mã xác minh',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: mediaHeight * 0.04),
                    Image.asset('assets/images/forget_icon.gif',
                        width: 150, height: 120),
                    SizedBox(height: mediaHeight * 0.04),
                    Form(
                      key: _formKey,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: PhoneNumberTextField(
                            controller: phoneInputField,
                          )),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: mediaHeight * 0.05),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFEC1C24),
                              borderRadius: BorderRadius.circular(25)),
                          height: mediaHeight * 0.06,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: const Center(
                            child: Text(
                              'Gửi mã xác minh',
                              style: TextStyle(
                                //height: 26,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await OTPService()
                                .sendOTP(context, phoneInputField.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Verify_Page(
                                      // phoneNumber: phoneInputField.text,
                                      )),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
