import 'dart:convert';

import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/Employee/User.dart';

class EmployeeRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<List<User>> getAllUser({required String token, String page = "1", String name = ""}) async {
    print('$_baseUrl/cmt-employee/all?page=$page&name=$name');
    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-employee/all?page=$page&name=$name'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"]['employee'];
      List<User> employee = it.map((e) {
        var user = User.fromJson(e);
        return user;
      }).toList();

      return employee;
    }

    return [];
  }

  Future<User> getDetailEmployee({required String token, required String id}) async {
    final response = await http.get(
      Uri.parse("${Config.apiUrl}/cmt-employee/detail?id=$id"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body)["employee"]);

      return user;
    }

    return User.fromJson({});
  }
}