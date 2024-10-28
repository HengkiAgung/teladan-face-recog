// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../bloc/attendance_log/attendance_log_bloc.dart'
    as attendance_log_bloc;
import '../../bloc/attendance_today/attendance_today_bloc.dart'
    as attendance_today_bloc;
import '../../bloc/employee/employee_bloc.dart' as employee_bloc;
import '../../bloc/request_attendance_list/request_attendance_list_bloc.dart'
    as request_attendance_list_bloc;
import '../../bloc/request_leavel_list/request_leave_list_bloc.dart'
    as request_leave_list_bloc;
import '../../bloc/request_shift_list/request_shift_list_bloc.dart'
    as request_shift_list_bloc;
import '../../bloc/summaries/summaries_bloc.dart' as summaries_bloc;
import '../../bloc/notification_badge/notification_badge_bloc.dart'
    as notification_badge_bloc;
import '../../bloc/current_shift/current_shift_bloc.dart' as current_shift_bloc;
import '../components/modal_bottom_sheet_component.dart';
import '../config.dart';
import 'middleware.dart';

class Auth {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> resetPassword(BuildContext context, String password) async {
    try {
      ModalBottomSheetComponent()
          .loadingIndicator(context, "Changging password, please wait");
      String token = await Auth().getToken();
      final response = await http.post(
        Uri.parse("${Config.apiUrl}/user/change-pass"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'password': password,
        }),
      );
      Navigator.pop(context);

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorMessage = json.decode(response.body)['message'];
        ModalBottomSheetComponent().errorIndicator(context, errorMessage);
      }
    } catch (error) {
      print(error.toString());
    }

    return false;
  }

  Future<List<dynamic>> login(
      BuildContext context, String email, String password) async {
    try {
      ModalBottomSheetComponent().loadingIndicator(context, "Loging in");
      final response = await http.post(
        Uri.parse("${Config.apiUrl}/login"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      Navigator.pop(context);

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['data']['token'];

        return [true, jsonDecode(response.body)['data']['is_new'], token];
      } else {
        final errorMessage = json.decode(response.body)['message'];
        ModalBottomSheetComponent().errorIndicator(context, errorMessage);
      }
    } catch (error) {
      print(error.toString());
    }

    return [false];
  }

  void register(BuildContext context, String username, String email,
      String password) async {
    try {
      final response = await http.post(
        Uri.parse("${Config.apiUrl}/register"),
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (jsonDecode(response.body)['data']?['token'] != null) {
        final token = jsonDecode(response.body)['data']['token'];

        persistToken(token);

        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        final errorMessage = json.decode(response.body)['message'];

        ModalBottomSheetComponent().errorIndicator(context, errorMessage);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<String> getToken() async {
    var value = await storage.read(key: 'token');

    return value ?? "";
  }

  Future<void> persistToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  void logOut(BuildContext context) {
    context
        .read<attendance_log_bloc.AttendanceLogBloc>()
        .add(attendance_log_bloc.LogOut());
    context
        .read<attendance_today_bloc.AttendanceTodayBloc>()
        .add(attendance_today_bloc.LogOut());
    context.read<employee_bloc.EmployeeBloc>().add(employee_bloc.LogOut());
    context
        .read<request_attendance_list_bloc.RequestAttendanceListBloc>()
        .add(request_attendance_list_bloc.LogOut());
    context
        .read<request_leave_list_bloc.RequestLeaveListBloc>()
        .add(request_leave_list_bloc.LogOut());
    context
        .read<request_shift_list_bloc.RequestShiftListBloc>()
        .add(request_shift_list_bloc.LogOut());
    context.read<summaries_bloc.SummariesBloc>().add(summaries_bloc.LogOut());
    context
        .read<notification_badge_bloc.NotificationBadgeBloc>()
        .add(notification_badge_bloc.LogOut());
    context
        .read<current_shift_bloc.CurrentShiftBloc>()
        .add(current_shift_bloc.LogOut());

    Middleware().redirectToLogin(context);
    deleteToken();
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
    await storage.deleteAll();
  }
}
