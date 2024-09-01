import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teladan/config.dart';

class NotificationRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<int> getNotifications({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/cmt-request/notification/badge'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        int attendance = jsonDecode(response.body)["data"]["count"];

        return attendance;
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getAttendanceNotifications({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/cmt-request/attendance/notification/badge'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        int attendance = jsonDecode(response.body)["data"]["count"];

        return attendance;
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getShiftNotifications({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/cmt-request/shift/notification/badge'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        int attendance = jsonDecode(response.body)["data"]["count"];

        return attendance;
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getTimeOffNotifications({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/cmt-request/time-off/notification/badge'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        int attendance = jsonDecode(response.body)["data"]["count"];

        return attendance;
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getAssignmentNotifications({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/cmt-request/assignment/notification/badge'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        int attendance = jsonDecode(response.body)["data"]["count"];

        return attendance;
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }
}
