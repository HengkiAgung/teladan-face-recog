import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teladan/models/Leave/UserLeaveHistory.dart';
import '../config.dart';

class LeaveRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<int> getLeaveQuota({required String token}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user/leave/quota/available'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)["data"];
      if (data is int) {
        return data;
      }
      return int.parse(data);
    }
    return 0;
  }

  Future<List<UserLeaveHistory>> getLeaveHistory(
      {required String token, int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user/leave/quota/history?page=${page.toString()}'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"]["history"];
      return it.map((e) {
        var data = UserLeaveHistory.fromJson(e);
        return data;
      }).toList();
    }
    return [];
  }
}
