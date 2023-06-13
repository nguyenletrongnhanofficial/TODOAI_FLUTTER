import 'package:flutter/material.dart';
import '/pages/login_page.dart';

class ResetPassConfirm extends StatefulWidget {
  const ResetPassConfirm({Key? key}) : super(key: key);

  @override
  State<ResetPassConfirm> createState() => _ResetPassConfirmState();
}

class _ResetPassConfirmState extends State<ResetPassConfirm> {
  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, statusBarHeight, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      alignment: Alignment.centerLeft,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      icon: Icon(Icons.close)),
                ),
                Center(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'LOVISER',
                          style: TextStyle(
                              color: Color(0xFF356899),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: const Image(
                                image: AssetImage(
                                    'assets/images/reset_pass_confirm.gif'))),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: const Text(
                            'Xác nhận',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: const Text(
                            'Mật khẩu của bạn đã được thay đổi. Vui lòng đăng nhập bằng mật khẩu mới của bạn.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(213, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                primary: const Color(0xFFEC1C24),
                                onPrimary: Colors.white),
                            child: FittedBox(
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  //height: 26,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
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
        ),
      ),
    );
  }
}
