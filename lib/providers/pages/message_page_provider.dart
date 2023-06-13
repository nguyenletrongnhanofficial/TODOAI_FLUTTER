import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/models/hives/userid.dart';
import 'dart:convert';
import 'dart:io';

import '../../../config/config.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/pages/login_page.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class MessagePageProvider with ChangeNotifier {
  MessagePageProvider() {
    initialize();
  }
  Future<void> initialize() async {
    final box = Hive.box<UserId>('userBox');
    UserId? userId = box.get('userid');
    if (userId != null) {
      current_user_id = userId.userid!;
    }
    notifyListeners();
  }

  late String current_user_id = '';

  Future<void> setCurrentUserId(String userid) async {
    current_user_id = userid;
    final box = Hive.box<UserId>('userBox');
    box.put('userid', UserId(userid: userid));
    notifyListeners();
  }
}
