class ProrateSetting {
  late int id;
  late String name;
  late int custom_number;
  late int holiday_as_working_day;

  ProrateSetting({
    required this.id,
    required this.name,
    required this.custom_number,
    required this.holiday_as_working_day,
  });

  ProrateSetting.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    custom_number = json['custom_number'] ?? 0;
    holiday_as_working_day = json['holiday_as_working_day'] ?? 0;
  }
}