import 'EmploymentStatus.dart';
import 'SubBranch.dart';
import 'User.dart';
import 'WorkingSchedule.dart';

class UserEmployment {
  late int id;
  late String employee_id;
  late String join_date;
  late String end_date;
  late String resign_date;
  late String barcode;
  late SubBranch subBranch;
  late WorkingSchedule workingSchedule;
  late EmploymentStatus employmentStatus;
  late User approvalLine;
  late User? user;

  UserEmployment({
    required this.id,
    required this.employee_id,
    required this.join_date,
    required this.end_date,
    required this.resign_date,
    required this.barcode,
    required this.subBranch,
    required this.workingSchedule,
    required this.employmentStatus,
    required this.approvalLine,
    required this.user,
  });

  UserEmployment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    employee_id = json['employee_id'] ?? "";
    join_date = json['join_date'] ?? "";
    end_date = json['end_date'] ?? "";
    resign_date = json['resign_date'] ?? "";
    barcode = json['barcode'] ?? "";
    subBranch = SubBranch.fromJson(json['working_schedule'] ?? {});
    workingSchedule = WorkingSchedule.fromJson(json['working_schedule'] ?? {});
    if (json['approval_line'] == null) {
      approvalLine = User.fromJson({});
    } else {
      approvalLine = User.fromJson(json['approval_line'] is !int ? json['approval_line'] : {});
    }
    user = User.fromJson(json['user'] ?? {});
    employmentStatus = EmploymentStatus.fromJson(json['employment_status'] ?? {});
  }
}