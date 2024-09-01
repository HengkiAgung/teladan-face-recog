class PaymentSchedule {
  late int id;
  late String name;
  late String payment_type;
  late int payroll_date;
  late int tax_with_salary;
  late int attendance_date_start;
  late int attendance_date_end;
  late int payroll_date_start;
  late int payroll_date_end;
  late int pay_last_month;
  late String start_date;
  late String cutoff_day;

  PaymentSchedule({
    required this.id,
    required this.name,
    required this.payment_type,
    required this.payroll_date,
    required this.tax_with_salary,
    required this.attendance_date_start,
    required this.attendance_date_end,
    required this.payroll_date_start,
    required this.payroll_date_end,
    required this.pay_last_month,
    required this.start_date,
    required this.cutoff_day,
  });

  PaymentSchedule.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    payment_type = json['payment_type'] ?? "";
    payroll_date = json['payroll_date'] ?? 0;
    tax_with_salary = json['tax_with_salary'] ?? 0;
    attendance_date_start = json['attendance_date_start'] ?? 0;
    attendance_date_end = json['attendance_date_end'] ?? 0;
    payroll_date_start = json['payroll_date_start'] ?? 0;
    payroll_date_end = json['payroll_date_end'] ?? 0;
    pay_last_month = json['pay_last_month'] ?? 0;
    start_date = json['start_date'] ?? "";
    cutoff_day = json['cutoff_day'] ?? "";
  }
}