class Role {
  late int id;
  late String name;
  late String guard_name;

  Role({
    required this.id,
    required this.name,
    required this.guard_name,
  });

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    guard_name = json['guard_name'] ?? "";
  }
}