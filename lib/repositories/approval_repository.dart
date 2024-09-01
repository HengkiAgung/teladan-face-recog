// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teladan/components/modal_bottom_sheet_component.dart';
import 'package:teladan/models/Assignment/Assignment.dart';
import 'package:teladan/utils/auth.dart';
import '../config.dart';

class ApprovalRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<List<dynamic>> getRequest({
    String page = "1",
    required String key,
    required String type,
    required dynamic model,
    required String token,
  }) async {
    final response =
        await http.post(Uri.parse('$_baseUrl/cmt-request/$type/get'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'page': page,
            }));

    if (jsonDecode(response.body)["status"] == "success") {
      Iterable it = jsonDecode(response.body)["data"][key];
      return it.map((e) {
        return model.fromJson(e);
      }).toList();
    }

    return [];
  }

  Future<dynamic> getDetailRequest({
    required String id,
    required String type,
    required dynamic model,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/$type/get/detail'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
      }),
    );

    if (jsonDecode(response.body)["status"] == "success") {
      return model.fromJson(jsonDecode(response.body)["data"]);
    }

    return model.fromJson({});
  }

  Future<bool> updateRequest({
    required String type,
    required String id,
    required String status,
    String? comment,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/$type/update/status'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
        'status': status,
        'comment': comment,
      }),
    );

    print(jsonDecode(response.body));

    if (jsonDecode(response.body)["status"] == "success") {
      return true;
    }

    return false;
  }

  Future<List<Assignment>> getAssignmentApproval({
    String page = "1",
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/assignment/get?page=$page'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"]["assignment"];
      return it.map((e) {
        var data = Assignment.fromJson(e);
        return data;
      }).toList();
    }

    return [];
  }

  Future<List> createData() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/personal/assignment/get/create-data'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)["data"];

      return [
        data["users"],
        data["days"],
      ];
    }

    return [];
  }

  Future<bool> makeAssignmentRequest({
    required BuildContext context,
    required String number,
    required String signed_by,
    required DateTime start_date,
    required DateTime end_date,
    required String override_holiday,
    required String name,
    required String location,
    required String latitude,
    required String longitude,
    required String working_start,
    required String working_end,
    required String radius,
    required String purpose,
    required dynamic work_schedule,
  }) async {
    String? token = await Auth().getToken();

    // if (working_shift_id == "") {
    //   // ignore: use_build_context_synchronously
    //   ModalBottomSheetComponent().errorIndicator(context, "Shift baru wajib diisi!");
    //   return false;
    // }

    ModalBottomSheetComponent()
        .loadingIndicator(context, "Sedang mengirim data...");

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/assignment/store'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'number': number,
        'signed_by': signed_by,
        'start_date':
            "${start_date.year}-${start_date.month}-${start_date.day}",
        'end_date': "${end_date.year}-${end_date.month}-${end_date.day}",
        'override_holiday': override_holiday,
        'name': name,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'working_start': working_start,
        'working_end': working_end,
        'radius': radius,
        'purpose': purpose,
        'work_schedule': work_schedule,
      }),
    );

    Navigator.pop(context);
    if (int.parse(response.statusCode.toString()[0]) == 2) {
      return true;
    } else {
      final errorMessage = json.decode(response.body)['message'];

      ModalBottomSheetComponent().errorIndicator(context, errorMessage);

      return false;
    }
  }

  Future<Assignment> getAssignmentApprovalDetail(
      {required String token, required int id}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/assignment/get/detail/$id'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("object");
    print('$_baseUrl/cmt-request/assignment/get/detail/$id');
    print(jsonDecode(response.body)["data"]);
    if (response.statusCode == 200) {
      var assignements =
          Assignment.fromJson(jsonDecode(response.body)["data"]["assignment"]);
      assignements.updateUserAssignments(jsonDecode(response.body)["data"]);
      return assignements;
    }

    return Assignment.fromJson({});
  }

  Future<bool> updateStatusRequestAssigment(
      {required String status, required int id}) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/assignment/update/status'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'assignment_id': id,
        'status': status,
      }),
    );

    if (jsonDecode(response.body)["status"] == "success") {
      return true;
    }

    return false;
  }

  Future<String> export({required int id, required int userId}) async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/personal/assignment/export/$id/$userId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (jsonDecode(response.body)["status"] == "success") {
      return jsonDecode(response.body)["data"];
    }

    return "";
  }
}
