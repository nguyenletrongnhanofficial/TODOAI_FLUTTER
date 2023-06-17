import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '/pages/forget_password_page.dart';
import 'home/home_page.dart';
import '/pages/onboarding.dart';
import '/pages/sign_up_page.dart';

import '/providers/pages/message_page_provider.dart';
import '../models/hives/count_app.dart';
import '../widgets/cupertino_bottom_sheet/src/bottom_sheets/cupertino_bottom_sheet.dart';
import '../widgets/custom_divider/custom_divider_widget.dart';
import '../pages/sign_up_page.dart';
import '../main.dart';
import '../config/config.dart';
import 'package:http/http.dart';
import '../widgets/custom_dialog/fail_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPasswordVisibleOld = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  late bool _isLoading = false;

  getOnboarding() async {
    final box = Hive.box<CountApp>('countBox');
    CountApp? count = box.get('countOnboarding');
    bool countOnboarding;

    if (count == null) {
      countOnboarding = false;
    } else {
      countOnboarding = count.countOnboarding!;
    }

    if (countOnboarding == false) {
      box.put('countOnboarding', CountApp(countOnboarding: true));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 390), () {
          showCupertinoModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Onboarding(),
          );
        });
      });
    }
    setState(() {});
  }
  // getOnboarding() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int countOnboarding = prefs.getInt('countShowcase') ?? 0;
  //   if (countOnboarding == 1) {
  //     saveOnboarding(true);
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Future.delayed(Duration(milliseconds: 390), () {
  //         showCupertinoModalBottomSheet(
  //           expand: false,
  //           context: context,
  //           backgroundColor: Colors.transparent,
  //           builder: (context) => Onboarding(),
  //         );
  //       });
  //     });
  //   }
  //   setState(() {});
  // }

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
      print(phone.text);
      print(password.text);
    } else {
      print('Form is invalid');
    }
  }

  void saveAccount(String phone, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', phone);
    prefs.setString('password', password);
  }

  @override
  void initState() {
    super.initState();
    getOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    void handleOnPressLogin() async {
      try {
        if (_isLoading) return;
        setState(() {
          _isLoading = true;
        });
        Response response = await post(
          Uri.parse("$baseUrl/auth/login"),
          body: {'phone': phone.text, 'password': password.text},
        );
        if (response.statusCode == 200) {
          final extractedData =
              json.decode(response.body) as Map<String, dynamic>;
          if (extractedData == null) {
            return;
          }
          print(extractedData["userid"]);

          Provider.of<MessagePageProvider>(context, listen: false)
              .setCurrentUserId(extractedData["userid"]);

          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage(
                      isMe: true,
                    )),
          );
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => LoginFailDialog());
        }
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }

    void handleOnPressSignUp() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUp(),
        ),
      );
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
    double sizesceen = MediaQuery.of(context).size.height;
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
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'TodoAi',
                      style: TextStyle(
                          color: Color(0xFF356899),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: padding.height * 0.01),
                          child: Container(
                            //width: MediaQuery.of(context).size.width * 0.9,
                            child: const Text(
                              'Chào mừng đã trở lại',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontFamily: 'Montserrat-Bold',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Image.asset('assets/images/hi.gif',
                            width: 45, height: 45)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, padding.height * 0.01,
                              0, padding.height * 0.02),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: const Text(
                                'TodoAi là ứng dụng sắp xếp lịch bằng trí tuệ nhân tạo đầu tiên tại Việt Nam',
                                style: TextStyle(
                                  fontFamily: 'AvertaStdCY-Semibold',
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              )),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: mediaHeight * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            shape: BoxShape.rectangle,
                          ),
                          child: TextFormField(
                              controller: phone,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xfff7f8f9),
                                hintText: 'Số điện thoại',
                                hintStyle: TextStyle(
                                  fontFamily: 'AvertaStdCY-Regular',
                                  color: Color(0xff616161),
                                ),
                                prefixIcon:
                                    Image.asset('assets/images/phone_icon.png'),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(25), //<-- ADD THIS
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'AvertaStdCY-Regular',
                                color: Colors.black,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Điền số điện thoại vào!";
                                } else {
                                  return null;
                                }
                              }),
                        ),
                        Container(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: mediaHeight * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            shape: BoxShape.rectangle,
                          ),
                          child: TextFormField(
                              controller: password,
                              obscureText: isPasswordVisibleOld,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xfff7f8f9),
                                hintText: 'Mật khẩu',
                                hintStyle: TextStyle(
                                  fontFamily: 'AvertaStdCY-Regular',
                                  color: Color(0xff616161),
                                ),
                                prefixIcon:
                                    Image.asset('assets/images/password.png'),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(25), //<-- ADD THIS
                                ),
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
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Điền mật khẩu!";
                                } else {
                                  return null;
                                }
                              }),
                        ),
                      ]),
                    ),
                    Container(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: padding.height * 0.02),
                      child: InkWell(
                        onTap: () {
                          print(phone.text);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: mediaHeight * 0.06,
                          // child: RoundedButton(
                          //   text: "Đăng nhập",
                          //   press: (){
                          //     print('lalalalalala');
                          //   },
                          //   color: Colors.red,
                          //   textColor: Colors.white,
                          // ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(213, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                primary: const Color(0xFFEC1C24),
                                onPrimary: Colors.white),
                            child: FittedBox(
                              child: _isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 4,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        const Text(
                                          'Đang tải...',
                                          style: TextStyle(
                                            fontFamily: 'AvertaStdCY-Semibold',
                                            //height: 26,
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'Đăng nhập',
                                      style: TextStyle(
                                        fontFamily: 'AvertaStdCY-Semibold',
                                        //height: 26,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                            onPressed: handleOnPressLogin,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: mediaHeight * 0.1,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Forget_pass()),
                            );
                          },
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              fontFamily: 'AvertaStdCY-Semibold',
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: mediaHeight * 0.1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: OrDivider()),
                    Container(
                      height: mediaHeight * 0.1,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Bạn chưa có tài khoản?',
                            style: TextStyle(
                              fontFamily: 'AvertaStdCY-Semibold',
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()),
                              );
                            },
                            child: const Text(
                              ' Đăng ký',
                              style: TextStyle(
                                fontFamily: 'AvertaStdCY-Semibold',
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
