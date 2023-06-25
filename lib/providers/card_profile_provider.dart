import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import '/config/config.dart';

class User {
  late String name;
  String? phone;

  User.fromJson(Map json) {
    name = json['name'];
    phone = json['phone'];
  }
}

class CardProfileProvider with ChangeNotifier {
  User? user;

  Future<void> fetchCurrentUser(String current_user_id) async {
    final url = Uri.parse('$baseUrl/auth/getUser/$current_user_id');
    try {
      final response = await get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      user = User.fromJson(extractedData['message']);
      notifyListeners();
    } catch (error) {
     
    }
  }
}
