import 'PaymentSchedule.dart';
import 'ProrateSetting.dart';

class UserSalary {
  late int id;
  late int basic_salary;
  late String salary_type;
  late int allow_for_overtime;
  late String overtime_working_day;
  late String overtime_day_off;
  late String overtime_national_holiday;
  late PaymentSchedule paymentSchedule;
  late ProrateSetting prorateSetting;

  UserSalary({
    required this.id,
    required this.basic_salary,
    required this.salary_type,
    required this.allow_for_overtime,
    required this.overtime_working_day,
    required this.overtime_day_off,
    required this.overtime_national_holiday,
    required this.paymentSchedule,
    required this.prorateSetting,
  });

  UserSalary.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    basic_salary = json['basic_salary'] ?? 0;
    salary_type = json['salary_type'] ?? "";
    allow_for_overtime = json['allow_for_overtime'] ?? 0;
    overtime_working_day = json['overtime_working_day'] ?? "";
    overtime_day_off = json['overtime_day_off'] ?? "";
    overtime_national_holiday = json['overtime_national_holiday'] ?? "";
    paymentSchedule = PaymentSchedule.fromJson(json['payment_schedule'] ?? {});
    prorateSetting = ProrateSetting.fromJson(json['prorate_setting'] ?? {});
  }
}