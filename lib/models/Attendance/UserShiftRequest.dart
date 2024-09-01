import '../Employee/WorkingShift.dart';

import '../Employee/User.dart';

class UserShiftRequest {
  late int id;
  late User? user;
  late WorkingShift workingShift;
  late User? approvalLine;
  late String status;
  late String date;
  late String notes;
  late String comment;

  UserShiftRequest();

  UserShiftRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    user = User.fromJson(json['user'] ?? {});
    workingShift = WorkingShift.fromJson(json['working_shift'] ?? {});
    if (json['approval_line'] is int) {
      approvalLine = null;      
    } else {
      approvalLine = User.fromJson(json['approval_line'] ?? {});
    }
    status = json['status'] ?? "";
    date = json['date'] ?? "";
    notes = json['notes'] ?? "";
    comment = json['comment'] ?? "";
  }

  fromJson(Map<String, dynamic> json) {
    return UserShiftRequest.fromJson(json);
  }
}