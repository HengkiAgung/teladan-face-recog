import 'WorkingSchedule.dart';
import 'WorkingShift.dart';

class WorkingScheduleShift {
  late int id;
  late WorkingSchedule workingSchedule;
  late WorkingShift workingShift;

  WorkingScheduleShift({
    required this.id,
    required this.workingSchedule,
    required this.workingShift,
  });

  WorkingScheduleShift.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    workingSchedule = WorkingSchedule.fromJson(json['working_schedule'] ?? {});
    workingShift = WorkingShift.fromJson(json['working_shift'] ?? {});
  }
}