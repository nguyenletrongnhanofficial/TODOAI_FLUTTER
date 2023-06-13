import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '/config/config.dart';
import '/pages/reset_pass_confirm_page.dart';

class ResetPass extends StatefulWidget {
  final String phoneNumber;
  const ResetPass({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  bool isPasswordVisibleOld = false;
  TextEditingController newPassword = TextEditingController();
  TextEditingController newPasswordConfirm = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> resetPass(String phoneNumber, String password) async {
    try {
      final resetPass = await Dio().put('$baseUrl/user/resetpassword',
          data: {'phoneNumber': phoneNumber, 'password': password});
      if (resetPass.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPassConfirm()),
        );
      } else {
        print('Failed to reset pass');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mediaHeight = !isLandscape
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 1.2;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
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
                      Center(
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
                              'Đặt lại mật khẩu',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: mediaHeight * 0.04),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: const Text(
                                'Nhập mật khẩu mới của bạn và xác nhận mật khẩu mới để đặt lại mật khẩu',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            MediaQuery.of(context).viewInsets.bottom == 0 &&
                                    MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                ? SizedBox(height: mediaHeight * 0.15)
                                : SizedBox(height: mediaHeight * 0.05),
                            Form(
                              key: _formKey,
                              child: SizedBox(
                                height: mediaHeight * 0.25,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height: mediaHeight * 0.1,
                                      child: TextFormField(
                                        controller: newPassword,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Hãy điền mật khẩu";
                                          } else if (value !=
                                              newPasswordConfirm.text) {
                                            return 'Mật khẩu không khớp';
                                          } else {
                                            return null;
                                          }
                                        },
                                        obscureText: isPasswordVisibleOld,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            hintText: 'Mật khẩu mới',
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
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: mediaHeight * 0.1,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Hãy điền mật khẩu";
                                            } else if (value !=
                                                newPasswordConfirm.text) {
                                              return 'Mật khẩu không khớp';
                                            } else {
                                              return null;
                                            }
                                          },
                                          controller: newPasswordConfirm,
                                          obscureText: isPasswordVisibleOld,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              hintText: 'Xác nhận mật khẩu mới',
                                              prefixIcon: Icon(Icons.key),
                                              suffixIcon: IconButton(
                                                icon: isPasswordVisibleOld
                                                    ? const Image(
                                                        color:
                                                            Color(0xFF60778C),
                                                        width: 24,
                                                        height: 24,
                                                        image: AssetImage(
                                                            'assets/images/eyeOff.png'))
                                                    : const Image(
                                                        color:
                                                            Color(0xFF60778C),
                                                        width: 24,
                                                        height: 24,
                                                        image: AssetImage(
                                                            'assets/images/eyeOn.png')),
                                                onPressed: () => setState(() =>
                                                    isPasswordVisibleOld =
                                                        !isPasswordVisibleOld),
                                              ),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            MediaQuery.of(context).viewInsets.bottom == 0 &&
                                    MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                ? SizedBox(height: mediaHeight * 0.2)
                                : SizedBox(height: mediaHeight * 0.1),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFFEC1C24),
                                    borderRadius: BorderRadius.circular(25)),
                                height: mediaHeight * 0.06,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: const Center(
                                  child: Text(
                                    'Đặt lại mật khẩu',
                                    style: TextStyle(
                                      //height: 26,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  resetPass(
                                      widget.phoneNumber, newPassword.text);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
