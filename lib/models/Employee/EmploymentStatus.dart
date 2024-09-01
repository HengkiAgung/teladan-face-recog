class EmploymentStatus {
  late int id;
  late String name;
  late int have_end_date;

  EmploymentStatus({
    required this.id,
    required this.name,
    required this.have_end_date,
  });

  EmploymentStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    have_end_date = json['have_end_date'] ?? 0;
  }
}