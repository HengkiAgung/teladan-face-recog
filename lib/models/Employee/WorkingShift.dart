class WorkingShift {
  late int id;
  late String name;
  late String working_start;
  late String working_end;
  late String break_start;
  late String break_end;
  late int late_check_in;
  late int late_check_out;

  late int min_check_in;
  late int max_check_out;
  late String overtime_before;
  late String overtime_after;
  late int show_in_request;

  WorkingShift({
    required this.id,
    required this.name,
    required this.working_start,
    required this.working_end,
    required this.break_start,
    required this.break_end,
    required this.late_check_in,
    required this.late_check_out,

    required this.min_check_in,
    required this.max_check_out,
    required this.overtime_before,
    required this.overtime_after,
    required this.show_in_request,
  });

  WorkingShift.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    working_start = json['working_start'] ?? "";
    working_end = json['working_end'] ?? "";
    break_start = json['break_start'] ?? "";
    break_end = json['break_end'] ?? "";
    late_check_in = json['late_check_in'] ?? 0;
    late_check_out = json['late_check_out'] ?? 0;
    
    min_check_in = json['start_attend'] ?? 0;
    max_check_out = json['end_attend'] ?? 0;
    overtime_before = json['overtime_before'] ?? "";
    overtime_after = json['overtime_after'] ?? "";
    show_in_request = json['show_in_request'] ?? 0;
  }
}