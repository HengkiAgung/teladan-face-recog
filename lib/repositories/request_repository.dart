// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:locale_plus/locale_plus.dart';
import 'package:teladan/models/Assignment/Assignment.dart';
import 'package:teladan/utils/helper.dart';

import '../components/modal_bottom_sheet_component.dart';
import '../config.dart';
import '../models/Attendance/LeaveRequestCategory.dart';
import '../models/Employee/WorkingShift.dart';
import '../utils/auth.dart';

class RequestRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<List<dynamic>> getRequest({String page = "1", required String type, required String key, required dynamic model, required String token,}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/$type/get?page=$page'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"][key];
      return it.map((e) {
        var data = model.fromJson(e);
        return data;
      }).toList();

    }
    return [];
  }

  Future<dynamic> getRequestDetail({required String id, required String type, required dynamic model, required String token}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/$type/get/detail'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      return model.fromJson(jsonDecode(response.body)["data"]);
    }

    return model.fromJson({});
  }

  Future<bool> makeAttendanceRequest(
    BuildContext context,
    DateTime selectedDate,
    TimeOfDay? selectedTimeIn,
    TimeOfDay? selectedTimeOut,
    TextEditingController? descriptionController,
    PlatformFile? selectedFile,
  ) async {
    String? token = await Auth().getToken();

    if (selectedTimeIn == null && selectedTimeOut == null) {
      ModalBottomSheetComponent().errorIndicator(context, 'Masukkan Check In atau Check Out!');

      return false;
    }

    ModalBottomSheetComponent().loadingIndicator(context, "Sedang mengirim data...");

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/cmt-request/personal/attendance/make'),
    ); 
    
    if (selectedFile != null) {
      var imageFile = await http.MultipartFile.fromPath(
        'file',
        selectedFile.path!,
        filename: selectedFile.name,
      );

      request.files.add(imageFile);
    }

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['date'] = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    request.fields['notes'] = descriptionController!.text;

    final secondsFromGMT = await LocalePlus().getSecondsFromGMT();

    int gmt = ((secondsFromGMT ?? 0) / 3600).round() - 8;

    if (selectedTimeIn != null) {
      String hour = selectedTimeIn.hour.toString();
      if (hour.length < 2) {
        hour = "0$hour";
      }
      String minute = selectedTimeIn.minute.toString();
      if (minute.length < 2) {
        minute = "0$minute";
      }
      request.fields['check_in'] = formatHourTime("$hour:$minute", gmt*-1);
    } 
    if (selectedTimeOut != null) {
      String hour = selectedTimeOut.hour.toString();
      if (hour.length < 2) {
        hour = "0$hour";
      }
      String minute = selectedTimeOut.minute.toString();
      if (minute.length < 2) {
        minute = "0$minute";
      }
      request.fields['check_out'] = formatHourTime("$hour:$minute", gmt*-1);
    }

    try {
      final response = await request.send();
 
      final responseString = await response.stream.bytesToString();
      final message = jsonDecode(responseString)["message"];

      Navigator.pop(context);

      if (int.parse(response.statusCode.toString()[0]) == 2) {
        return true;
      } else {
        ModalBottomSheetComponent().errorIndicator(context, message);

        return false;
      }
    } catch (e) {
      Navigator.pop(context);
      ModalBottomSheetComponent().errorIndicator(context, "Error sendiring request: $e");

      return false;
    }
  }

  Future<List<WorkingShift>> getAllWorkingShift() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/get/working-shift'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"];
      List<WorkingShift> shift = it.map((e) {
        var shift = WorkingShift.fromJson(e);
        return shift;
      }).toList();

      return shift;
    }

    return [];
  }

  Future<WorkingShift> getCurrentShift({required String token}) async {
        final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/personal/shift/get/current/shift'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return WorkingShift.fromJson(jsonDecode(response.body)["data"]);
    }
    return WorkingShift.fromJson({});
  }

  Future<bool> makeShiftRequest(
    BuildContext context,
    DateTime date,
    String working_shift_id,
    String? reason,
  ) async {
    String? token = await Auth().getToken();
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day); 

    if (working_shift_id == "") {
      ModalBottomSheetComponent().errorIndicator(context, "Shift baru wajib diisi!");
      return false;
    }

    if (date.isBefore(now)) {
      ModalBottomSheetComponent().errorIndicator(context, "Tanggal mulai tidak boleh lebih kecil dari sekarang!");
      return false;
    }

    ModalBottomSheetComponent().loadingIndicator(context, "Sedang mengirim data...");

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/shift/make'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'date': "${date.year}-${date.month}-${date.day}",
        'working_shift_id': working_shift_id,
        'notes': reason,
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

  Future<bool> makeLeaveRequest({
    required BuildContext context,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay? working_start,
    required TimeOfDay? working_end,
    required LeaveRequestCategory? category,
    required String? reason,
    required PlatformFile? selectedFile,
  }) async {
    String? token = await Auth().getToken();

    if (category == null || category.id == 0) {
      ModalBottomSheetComponent().errorIndicator(context, "Kolom kategori wajib diisi!");
      return false;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/cmt-request/personal/time-off/make'),
    ); 
    
    if (category.attachment == 1 || selectedFile != null) {
      if (selectedFile == null) {
        ModalBottomSheetComponent().errorIndicator(context, "File bukti wajib diisi!");
        return false;
      }

      var imageFile = await http.MultipartFile.fromPath(
        'file',
        selectedFile.path!,
        filename: selectedFile.name,
      );

      request.files.add(imageFile);
    }


    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';  
    request.fields['leave_request_category_id'] = category.id.toString();
    request.fields['notes'] = reason ?? "";

    if (category.half_day != 1) {

      if (endDate.isBefore(startDate)) {
        ModalBottomSheetComponent().errorIndicator(context, "Tanggal selesai tidak boleh lebih kecil dari tanggal mulai!");
        return false;
      }

      request.fields['start_date'] = "${startDate.year}-${startDate.month}-${startDate.day}";
      request.fields['end_date'] = "${endDate.year}-${endDate.month}-${endDate.day}";
    } else {
      if (working_start == null && working_end == null) {
        ModalBottomSheetComponent().errorIndicator(context, 'Masukkan Check In atau Check Out!');

        return false;
      }

      if (working_start != null) {
        String hour = working_start.hour.toString();
        if (hour.length < 2) {
          hour = "0$hour";
        }
        String minute = working_start.minute.toString();
        if (minute.length < 2) {
          minute = "0$minute";
        }
        request.fields['working_start'] = "$hour:$minute";
      } 

      if (working_end != null) {
        String hour = working_end.hour.toString();
        if (hour.length < 2) {
          hour = "0$hour";
        }
        String minute = working_end.minute.toString();
        if (minute.length < 2) {
          minute = "0$minute";
        }
        request.fields['working_end'] = "$hour:$minute";
      } 

      request.fields['date'] = "${startDate.year}-${startDate.month}-${startDate.day}";
    }

    ModalBottomSheetComponent().loadingIndicator(context, "Sedang mengirim data...");

    try {
      final response = await request.send();

      Navigator.pop(context);
      if (int.parse(response.statusCode.toString()[0]) == 2) {
        return true;
      } else {
        var result = await response.stream.bytesToString();
        String message = result.split('"message":"')[1].split('"}')[0];

        ModalBottomSheetComponent().errorIndicator(context, message);
        return false;
      }
    } catch (e) {
      Navigator.pop(context);
      ModalBottomSheetComponent().errorIndicator(context, "Error sendiring request: $e");

      return false;
    }
  }

  Future<List<LeaveRequestCategory>> getAllLeaveRequestCategory() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/get/category'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"];

      List<LeaveRequestCategory> categories = it.map((e) {
        var category = LeaveRequestCategory.fromJson(e);
        return category;
      }).toList();

      return categories;
    }

    return [];
  }

  Future<bool> cancelRequest({required int id, required String type}) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/$type/cancel'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> makeAssignmentRequest({required BuildContext context,
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

    ModalBottomSheetComponent().loadingIndicator(context, "Sedang mengirim data...");

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/assignment/store'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'signed_by' : signed_by,
        'start_date' : "${start_date.year}-${start_date.month}-${start_date.day}",
        'end_date' : "${end_date.year}-${end_date.month}-${end_date.day}",
        'override_holiday' : override_holiday,
        'name' : name,
        'location' : location,
        'latitude' : latitude,
        'longitude' : longitude,
        'working_start' : working_start,
        'working_end' : working_end,
        'radius' : radius,
        'purpose' : purpose,
        'work_schedule' : work_schedule,
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
  
  Future<bool> cancelAssignmentRequest({required int id}) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/assignment/cancel'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
  
  Future<List<Assignment>> getAssignmentRequest({String page = "1", required String token,}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/personal/assignment/get/request?page=$page'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"]["assignments"];

      return it.map((e) {
        var data = Assignment.fromJson(e);
        return data;
      }).toList();
    }

    return [];
  }

  Future<List> getAssignmentRequestDetail({required String token, required int id}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/personal/assignment/get/detail/$id'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      var assignment = Assignment.fromJson(jsonDecode(response.body)["data"]["assignment"]);
      var pdf = jsonDecode(response.body)["data"]["pdf"];

      return [
        assignment,
        pdf,
      ];
    }

    return [];
  }

  Future<List<dynamic>> getCreateDataAssignment({String page = "1"}) async {
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
}