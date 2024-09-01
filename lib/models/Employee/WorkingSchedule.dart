class WorkingSchedule {
  late int id;
  late String name;
  late String effective_date;
  late int override_national_holiday;
  late int override_company_holiday;
  late int override_special_holiday;

  WorkingSchedule({
    required this.id,
    required this.name,
    required this.effective_date,
    required this.override_national_holiday,
    required this.override_company_holiday,
    required this.override_special_holiday,
  });

  WorkingSchedule.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    effective_date = json['effective_date'] ?? "";
    override_national_holiday = json['override_national_holiday'] ?? 0;
    override_company_holiday = json['override_company_holiday'] ?? 0;
    override_special_holiday = json['override_special_holiday'] ?? 0;
  }
}