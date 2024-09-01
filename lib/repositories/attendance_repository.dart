// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;
import 'package:teladan/components/modal_bottom_sheet_component.dart';

import '../models/Attendance.dart';
import '../config.dart';
import '../models/Summaries.dart';

class AttendanceRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<Attendance> getAttendanceDetail(
      {required String date, required String token}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-attendance/history/detail'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'date': date,
      }),
    );

    if (response.statusCode == 200) {
      Attendance attendance =
          Attendance.fromJson(jsonDecode(response.body)["data"] ?? {});

      return attendance;
    }

    return Attendance.fromJson(jsonDecode(response.body));
  }

  Future getImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
      preferredCameraDevice: CameraDevice.front,
    );
    if (image == null) return;

    final imageTemporary = File(image.path);

    return imageTemporary;
  }

  Future getLocation() async {
    Location location = Location();

    bool serviceEneabled = await location.serviceEnabled();
    if (!serviceEneabled) {
      serviceEneabled = await location.requestService();
      if (!serviceEneabled) {
        return Future.error("Location disabled");
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.error("Location permissions are denied");
      }
    }

    return await location.getLocation();
  }

  Future<bool> validateLocation(BuildContext context, String token,
      String latitude, String longitude) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-attendance/attend/location/validate'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    final bodyResponse = json.decode(response.body);

    if (bodyResponse["status"] == "success") {
      return true;
    }

    final errorMessage = json.decode(response.body)['message'];
    Navigator.pop(context);
    ModalBottomSheetComponent().errorIndicator(context, errorMessage);

    return false;
  }

  Future<bool> checkIn(BuildContext context, String token) async {
    try {
      String latitude = "0";
      String longitude = "0";

      ModalBottomSheetComponent()
          .loadingIndicator(context, "Sedang memeriksa lokasimu...");

      await getLocation().then((value) {
        latitude = '${value.latitude}';
        longitude = '${value.longitude}';
        // latitude = '-1.249637';
        // longitude = '116.877503';
      });

      bool validate =
          await validateLocation(context, token, latitude, longitude);

      if (validate) {
        Navigator.pop(context);
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$_baseUrl/cmt-attendance/attend/check-in'),
        );
        var data = await getImage();
        if (data == null) {
          throw 'Silahkan ambil ulang foto untuk melakukan check in';
        }

        var imageFile = await http.MultipartFile.fromPath(
          'file',
          data.path,
          filename: "absen.jpg",
        );
        ModalBottomSheetComponent()
            .loadingIndicator(context, "Sedang mengirim data...");

        request.files.add(imageFile);

        request.headers['Accept'] = 'application/json';
        request.headers['Content-Type'] = 'multipart/form-data';
        request.headers['Authorization'] = 'Bearer $token';
        request.fields['latitude'] = latitude;
        request.fields['longitude'] = longitude;

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
          ModalBottomSheetComponent()
              .errorIndicator(context, "Error sending request: $e");

          return false;
        }
      }

      return false;
    } catch (e) {
      ModalBottomSheetComponent().errorIndicator(context, e.toString());

      return false;
    }
  }

  Future<bool> checkOut(BuildContext context, String token) async {
    try {
      String latitude = "0";
      String longitude = "0";

      ModalBottomSheetComponent()
          .loadingIndicator(context, "Sedang memeriksa lokasimu...");

      await getLocation().then((value) {
        latitude = '${value.latitude}';
        longitude = '${value.longitude}';
        // latitude = '-1.249637';
        // longitude = '116.877503';
      });

      bool validate =
          await validateLocation(context, token, latitude, longitude);

      if (validate) {
        Navigator.pop(context);

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$_baseUrl/cmt-attendance/attend/check-out'),
        );
        var data = await getImage();
        if (data == null) {
          throw 'Silahkan ambil ulang foto untuk melakukan check out';
        }

        var imageFile = await http.MultipartFile.fromPath(
          'file',
          data.path,
          filename: "absen.jpg",
        );

        ModalBottomSheetComponent()
            .loadingIndicator(context, "Sedang mengirim data...");

        request.files.add(imageFile);

        request.headers['Accept'] = 'application/json';
        request.headers['Content-Type'] = 'multipart/form-data';
        request.headers['Authorization'] = 'Bearer $token';
        request.fields['latitude'] = latitude;
        request.fields['longitude'] = longitude;

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
          ModalBottomSheetComponent()
              .errorIndicator(context, "Error sending request: $e");

          return false;
        }
      }

      return false;
    } catch (e) {
      ModalBottomSheetComponent().errorIndicator(context, e.toString());

      return false;
    }
  }

  Future<List<Attendance>> getHistoryAttendance(
      {String page = "1", required String token, int month = 0, int year = 0}) async {

    if (month == 0) {
      DateTime now = DateTime.now();
      month = now.month;
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-attendance/history?page=$page&filterMonth=$month&filterYear=$year&itemCount=100'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"]['attendance'];

      List<Attendance> attendance = it.map((e) {
        return Attendance.fromJson(e);
      }).toList();

      return attendance;
    }

    return [];
  }

  Future<Summaries> getSummaries(
    String? startDate, String? endDate, token) async {

    DateTime now = DateTime.now();
    int month = now.day > 27 ? now.month : now.month - 1;
    String date = "${now.year}-$month-27";

    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-attendance/summaries/me?startDate=$date'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Summaries.fromJson(jsonDecode(response.body)["data"]["summaries"]);
    }

    return Summaries.fromJson({});
  }
}
