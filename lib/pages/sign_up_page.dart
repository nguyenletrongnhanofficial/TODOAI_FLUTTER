import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/custom_divider/custom_divider_Widget.dart';
import 'package:http/http.dart';
import '../pages/login_page.dart';
import '../config/config.dart';
import 'dart:convert';
import '/pages/verify_page.dart';
import '/modules/profile/services/otp.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  State<SignUp> createState() => _SignUpState();
}

String emailValue = "";
String phoneValue = "";
String passwordValue = "";
String passwordConfirmValue = "";
String nameValue = "";

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordConfirm = TextEditingController();

  bool isPasswordVisibleOld = true;
  @override
  Widget build(BuildContext context) {
    void handleOnPressSignUp() async {
      try {
        Response response =
            await post(Uri.parse('$baseUrl/auth/createUser'), body: {
          'email': email.text,
          'phone': phone.text,
          'password': password.text,
          'passwordConfirm': passwordConfirm.text,
          'name': name.text
        });
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        if (extractedData == null) {
          return;
        }
        print(extractedData["message"]);
        if (response.statusCode == 200) {
          print(email.text);
          print(password.text);
          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const Login(),
          //   ),
          // );
        } else {
          print("Failed");
        }
      } catch (e) {
        print(e);
      }
      print(email.text);
      print(password.text);
      print(passwordConfirm.text);
      print(name.text);
    }

    Size padding = MediaQuery.of(context).size;
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Center(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, statusBarHeight, 0, 0),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    // IconButton(
                    //     alignment: Alignment.centerLeft,
                    //     padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //     icon: Icon(Icons.arrow_back_ios)),
                    const Text(
                      'LOVISER',
                      style: TextStyle(
                          color: Color(0xFF356899),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Đăng ký tài khoản',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Để sau',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: padding.height * 0.01),
                          child: Container(
                              height: mediaHeight * 0.06,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: const Text(
                                'Loviser nền tảng việc làm tự do về tình cảm đầu tiên tại Việt Nam',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              )),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: mediaHeight * 0.1,
                      child: TextFormField(
                        controller: name,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Họ và tên',
                          prefixIcon: Icon(Icons.people),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: mediaHeight * 0.1,
                      child: TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Số điện thoại',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: mediaHeight * 0.1,
                      child: TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.mail),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Điền email!";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: mediaHeight * 0.1,
                      child: TextFormField(
                          controller: password,
                          obscureText: isPasswordVisibleOld,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              hintText: 'Mật khẩu',
                              prefixIcon: Icon(Icons.key),
                              suffixIcon: IconButton(
                                icon: isPasswordVisibleOld
                                    ? const Image(
                                        color: Color(0xFF60778C),
                                        width: 24,
                                        height: 24,
                                        image: AssetImage(
                                            'assets/images/eyeOff.png'))
                                    : const Image(
                                        color: Color(0xFF60778C),
                                        width: 24,
                                        height: 24,
                                        image: AssetImage(
                                            'assets/images/eyeOn.png')),
                                onPressed: () => setState(() =>
                                    isPasswordVisibleOld =
                                        !isPasswordVisibleOld),
                              ),
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Điền mật khẩu!";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: mediaHeight * 0.12,
                      child: TextFormField(
                          controller: passwordConfirm,
                          obscureText: isPasswordVisibleOld,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              hintText: 'Xác nhận mật khẩu',
                              prefixIcon: Icon(Icons.key),
                              suffixIcon: IconButton(
                                icon: isPasswordVisibleOld
                                    ? const Image(
                                        color: Color(0xFF60778C),
                                        width: 24,
                                        height: 24,
                                        image: AssetImage(
                                            'assets/images/eyeOff.png'))
                                    : const Image(
                                        color: Color(0xFF60778C),
                                        width: 24,
                                        height: 24,
                                        image: AssetImage(
                                            'assets/images/eyeOn.png')),
                                onPressed: () => setState(() =>
                                    isPasswordVisibleOld =
                                        !isPasswordVisibleOld),
                              ),
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Điền mật khẩu!";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: mediaHeight * 0.06,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(213, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            primary: const Color(0xFFEC1C24),
                            onPrimary: Colors.white),
                        child: const FittedBox(
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              //height: 26,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            emailValue = email.text;
                            phoneValue = phone.text;
                            passwordValue = password.text;
                            passwordConfirmValue = passwordConfirm.text;
                            nameValue = name.text;
                            await OTPService().sendOTP(context, '+84377712971');
                          } catch (e) {
                            // Xử lý lỗi ở đây
                          }
                        },
                        // onPressed: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Verify_Page()),
                        //   );
                        // },
                      ),
                    ),
                    Container(
                        height: mediaHeight * 0.07,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: OrDivider()),

                    Container(
                      height: mediaHeight * 0.03,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Bạn đã có tài khoản?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              ' Đăng nhập',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          )
        ]),
      ),
    );
  }
}
