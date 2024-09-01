class Attendance {
  late String date;
  late String attendance_code;
  late String check_in;
  late String check_out;
  late String shift_name;
  late String day_off_code;
  late String working_start;
  late String working_end;
  late int late_check_in;
  late int late_check_out;
  late String check_in_file;
  late String check_out_file;

  late int id;
  late String overtime_before;
  late String overtime_after;
  late int overtime;
  late double check_in_latitude;
  late double check_in_longitude;
  late double check_out_latitude;
  late double check_out_longitude;

  Attendance({
    required this.date,
    required this.attendance_code,
    required this.check_in,
    required this.check_out,
    required this.shift_name,
    required this.day_off_code,
    required this.working_start,
    required this.working_end,
    required this.late_check_in,
    required this.late_check_out,
    required this.check_in_file,
    required this.check_out_file,

    required this.id,
    required this.overtime_before,
    required this.overtime_after,
    required this.overtime,
    required this.check_in_latitude,
    required this.check_in_longitude,
    required this.check_out_latitude,
    required this.check_out_longitude,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    date = json['date'] ?? "";
    attendance_code = json['attendance_code'] ?? "";
    check_in = json['check_in'] ?? "";
    check_out = json['check_out'] ?? "";
    shift_name = json['shift_name'] ?? "";
    day_off_code = json['day_off_code'] ?? "";
    working_start = json['working_start'] ?? "";
    working_end = json['working_end'] ?? "";
    late_check_in = json['late_check_in'] ?? 0;
    late_check_out = json['late_check_out'] ?? 0;
    check_in_file = json['check_in_file'] ?? "";
    check_out_file = json['check_out_file'] ?? "";

    id = json['id'] ?? 0;
    overtime_before = json['overtime_before'] ?? "";
    overtime_after = json['overtime_after'] ?? "";
    overtime = json['overtime'] ?? 0;
    check_in_latitude = json['check_in_latitude'] != null ? double.parse(json['check_in_latitude']) : 0;
    check_in_longitude = json['check_in_longitude'] != null ? double.parse(json['check_in_longitude']) : 0;
    
    check_out_latitude = json['check_out_latitude'] != null ? double.parse(json['check_out_latitude']) : 0;
    check_out_longitude = json['check_out_longitude'] != null ? double.parse(json['check_out_longitude']) : 0;
  }
}