class Department {
  late int id;
  late String department_name;
  late String department_alias;

  Department({
    required this.id,
    required this.department_name,
    required this.department_alias,
  });

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    department_name = json['department_name'] ?? "";
    department_alias = json['department_alias'] ?? "";
  }
}