import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/ri.dart';
// import 'package:loviser/modules/profile/pages/my_profile_page.dart';
// import 'package:loviser/pages/applications.dart';
// import '../pages/settings.dart';

import 'package:provider/provider.dart';
import '/providers/card_profile_provider.dart';
import '/providers/pages/message_page_provider.dart';
// import '../providers/page/message_page/user_image_provider.dart';
// import '../modules/rich_text_edit/pages/resume_page.dart';
// import '/pages/resume_page.dart';
import '/pages/login_page.dart';
// import '/pages/user_post_fee_page.dart';

class NavigationDrawerProfile extends StatelessWidget {
  final bool isMe;
  final User? user;
  const NavigationDrawerProfile(
      {super.key, this.isMe = false, required this.user});

  final padding = const EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    // String avatar =
    //     Provider.of<UserImageProvider>(context, listen: false).avatar;
    String avatar =
        "https://haycafe.vn/wp-content/uploads/2022/03/Anh-gai-Trung-Quoc.jpg";
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print(width);
    print(height);
    return Drawer(
      width: width * 0.78,
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: padding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.0465,
                ),
                // CircleAvatar(
                //   backgroundImage: NetworkImage(avatar),
                //   radius: width * 0.0763,
                // ),
                CachedNetworkImage(
                  imageUrl: avatar,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(
                              30.0) //                 <--- border radius here
                          ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                SizedBox(
                  height: height * 0.012385,
                ),
                Text(
                  '${user?.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: width * 0.0509,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Đã xác minh",
                      style: TextStyle(
                        fontSize: width * 0.0381,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.0102,
                    ),
                    Iconify(
                      Ic.round_verified,
                      color: Colors.blue,
                      size: width * 0.033,
                    ),
                  ],
                ),
                // TextButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const MyProfilePage(
                //           isMe: true,
                //         ),
                //       ),
                //     );
                //   },
                //   child: Text(
                //     "Thông tin cá nhân",
                //     style: TextStyle(
                //         fontSize: width * 0.03815,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.red),
                //   ),
                // ),
                const SizedBox(
                  child: Divider(color: Colors.grey),
                ),
                buildMenuItem(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        ListTile(
          leading: const Icon(
            Icons.info_outline,
            color: Colors.grey,
          ),
          title: Transform(
            transform: Matrix4.translationValues(-width * 0.045, 0.0, 0.0),
            child: Text(
              "Thông tin cá nhân",
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.0381,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          hoverColor: Colors.blue[100],
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const MyProfilePage(
            //       isMe: true,
            //     ),
            //   ),
            // );
          },
        ),
        ListTile(
          leading: const Icon(
            FontAwesomeIcons.list,
            color: Colors.grey,
          ),
          title: Transform(
            transform: Matrix4.translationValues(-width * 0.045, 0.0, 0.0),
            child: Text(
              "Danh sách công việc",
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.0381,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          hoverColor: Colors.blue[100],
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const Applications(),
            //   ),
            // );
          },
        ),
        ListTile(
          leading: const Icon(
            FontAwesomeIcons.listCheck,
            color: Colors.grey,
          ),
          title: Transform(
            transform: Matrix4.translationValues(-width * 0.045, 0.0, 0.0),
            child: Text(
              "Công việc đã hoàn thành",
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.0381,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          hoverColor: Colors.blue[100],
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ResumePage(),
            //   ),
            // );
          },
        ),
        // ListTile(
        //   leading: const Icon(
        //     FontAwesomeIcons.user,
        //     color: Colors.grey,
        //   ),
        //   title: Transform(
        //     transform: Matrix4.translationValues(-width * 0.045, 0.0, 0.0),
        //     child: Text(
        //       "Sơ yếu lí lịch",
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: width * 0.0381,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        //   hoverColor: Colors.blue[100],
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ResumePage(),
        //       ),
        //     );
        //   },
        // ),
        // ListTile(
        //   leading: const Icon(
        //     Icons.list_alt_rounded,
        //     color: Colors.grey,
        //   ),
        //   title: Transform(
        //     transform: Matrix4.translationValues(-width * 0.045, 0.0, 0.0),
        //     child: Text(
        //       "Bài đăng tìm Freelance",
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: width * 0.0381,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        //   hoverColor: Colors.blue[100],
        //   onTap: () {
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(
        //     //     builder: (context) => UserPostFee(),
        //     //   ),
        //     // );
        //   },
        // ),
        // ListTile(
        //   leading: const Icon(
        //     Icons.list_alt_rounded,
        //     color: Colors.grey,
        //   ),
        //   title: Transform(
        //     transform: Matrix4.translationValues(-width * 0.045, 0.0, 0.0),
        //     child: Text(
        //       "Bài đăng tư vấn miễn phí",
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: width * 0.0381,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        //   hoverColor: Colors.blue[100],
        //   onTap: () {
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(
        //     //     builder: (context) => ResumePage(),
        //     //   ),
        //     // );
        //   },
        // ),
        ListTile(
          leading: const Icon(
            Icons.settings,
            color: Colors.grey,
          ),
          title: Transform(
            transform: Matrix4.translationValues(-width * 0.045, 0.0, 0.0),
            child: Text(
              "Cài đặt",
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.0381,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          hoverColor: Colors.blue[100],
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const Settings(),
            //   ),
            // );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          title: Transform(
            transform: Matrix4.translationValues(-width * 0.045, 0.0, 0.0),
            child: Text(
              "Đăng xuất",
              style: TextStyle(
                color: Colors.red,
                fontSize: width * 0.0381,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          hoverColor: Colors.blue[100],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
            );
          },
        ),
      ],
    );
  }
}
