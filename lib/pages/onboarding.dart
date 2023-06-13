import 'package:lottie/lottie.dart';
import '/pages/sign_up_page.dart';

import '../utils/color.dart';
import '../widgets/onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  final Color kDarkBlueColor = const Color(0xFF053149);

  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return OnBoardingSlider(
      finishButtonTextStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'Montserrat-Bold',
        fontSize: height * 0.03,
      ),
      finishButtonText: 'Đăng nhập',
      onFinish: () {
        Navigator.pop(context);
      },
      middle: Container(
        width: 37,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(9),
        ),
      ),
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: AppColor.mainColor,
      ),
      trailing: Text(
        'Đăng ký',
        style: TextStyle(
          height: 1.5,
          fontFamily: 'AvertaStdCY-Semibold',
          fontSize: height * 0.025,
          fontWeight: FontWeight.w100,
          color: kDarkBlueColor,
        ),
      ),
      trailingFunction: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const SignUp(),
          ),
        );
      },
      controllerColor: AppColor.mainColor,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      centerBackground: true,
      background: [
        Lottie.asset(
          'assets/lotties/hi.json',
          height: height * 0.4,
        ),
        Lottie.asset(
          'assets/lotties/sad.json',
          height: height * 0.4,
        ),
        Lottie.asset(
          'assets/lotties/send_love.json',
          height: height * 0.4,
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Container(
              //   width: 50,
              //   height: 10,
              //   decoration: BoxDecoration(
              //     color: Colors.black,
              //     borderRadius: BorderRadius.circular(50),
              //   ),
              // ),
              SizedBox(
                height: height * 0.45,
              ),
              Text(
                'Cảm ơn bạn đã sử dụng LOVISER..!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF053149),
                  fontFamily: 'Montserrat-Bold',
                  fontSize: height * 0.04,
                ),
              ),

              // const SizedBox(
              //   height: 20,
              // ),
              // Text(
              //   'Bạn đăng bài và chờ những freelancer giàu kinh nghiệm đến ứng tuyển vào vấn đề của bạn',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     height: 1.5,
              //     fontFamily: 'AvertaStdCY-Semibold',
              //     fontSize: height * 0.025,
              //     fontWeight: FontWeight.w100,
              //     color: AppColor.describetextcolor,
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: height * 0.43,
              ),
              Text(
                'Bạn là người có kinh nghiệm trong tình yêu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF053149),
                  fontFamily: 'Montserrat-Bold',
                  fontSize: height * 0.04,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Chúng tôi sẽ kết nối với những người đang cần bạn tư vấn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontFamily: 'AvertaStdCY-Semibold',
                  fontSize: height * 0.025,
                  fontWeight: FontWeight.w100,
                  color: AppColor.describetextcolor,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: height * 0.43,
              ),
              Text(
                'Bạn là người có kinh nghiệm trong tình yêu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF053149),
                  fontFamily: 'Montserrat-Bold',
                  fontSize: height * 0.04,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Chúng tôi sẽ kết nối với những người đang cần bạn tư vấn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontFamily: 'AvertaStdCY-Semibold',
                  fontSize: height * 0.025,
                  fontWeight: FontWeight.w100,
                  color: AppColor.describetextcolor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
