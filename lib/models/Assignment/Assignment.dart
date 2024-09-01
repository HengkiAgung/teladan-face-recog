import 'package:teladan/models/Assignment/UserAssignment.dart';

import '../Employee/User.dart';

class Assignment {
  late int id;
  late User user;
  late User signedBy;
  late String number;
  late String start_date;
  late String end_date;
  late int override_holiday;
  late String name;
  late String location;
  late String latitude;
  late String longitude;
  late String working_start;
  late String working_end;
  late int radius;
  late String purpose;
  late String status;
  late List<UserAssignment> user_assignments;

  Assignment({
    required this.id,
    required this.user,
    required this.signedBy,
    required this.number,
    required this.start_date,
    required this.end_date,
    required this.override_holiday,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.working_start,
    required this.working_end,
    required this.radius,
    required this.purpose,
    required this.status,
    required this.user_assignments,
  });

  Assignment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    user = User.fromJson(json['user'] ?? {});
    signedBy = User.fromJson(json['signed_by'] ?? {});
  
    longitude = json['longitude'] ?? "0";
    number = json['number'] ?? "";
    start_date = json['start_date'] ?? "";
    end_date = json['end_date'] ?? "";
    location = json['location'] ?? "0";
    latitude = json['latitude'] ?? "";
    override_holiday = json['override_holiday'] ?? 0;
    name = json['name'] ?? "";
    working_start = json['working_start'] ?? "";
    working_end = json['working_end'] ?? "";
    radius = json['radius'] ?? 0;
    purpose = json['purpose'] ?? "";
    status = json['status'] ?? "";

    user_assignments = [];
    if (json['user_assignments'] != null) {
      json['user_assignments'].forEach((v) {
        user_assignments.add(UserAssignment.fromJson(v));
      });
    }
  }

  updateUserAssignments(Map<String, dynamic> json) {
    user_assignments = [];
    if (json['user'] != null) {
      json['user'].forEach((v) {
        user_assignments.add(UserAssignment.fromJson(v));
      });
    }
  }
}
