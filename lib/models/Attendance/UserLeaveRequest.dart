import 'LeaveRequestCategory.dart';

import '../Employee/User.dart';

class UserLeaveRequest {
  late int id;
  late User? user;
  late User? approvalLine;
  late LeaveRequestCategory? leaveRequestCategory;
  late String status;
  late String notes;
  late String comment;
  late String file;
  late String start_date;
  late String end_date;
  late int taken;
  late String? date;
  late String? working_start;
  late String? working_end;
  
  UserLeaveRequest();

  UserLeaveRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    user = User.fromJson(json['user'] ?? {});
    approvalLine = json['approval_line'] is int ? null : User.fromJson(json['approval_line'] ?? {});
    leaveRequestCategory = LeaveRequestCategory.fromJson(json['leave_request_category'] ?? {});

    date = json['date'] ?? null;
    working_start = json['working_start'] ?? null;
    working_end = json['working_end'] ?? null;
    status = json['status'] ?? "";
    start_date = json['start_date'] ?? "";
    end_date = json['end_date'] ?? "";
    taken = json['taken'] ?? 0;
    notes = json['notes'] ?? "";
    comment = json['comment'] ?? "";
    file = json['file'] ?? "";

  }

  fromJson(Map<String, dynamic> json) {
    return UserLeaveRequest.fromJson(json);
  }
}