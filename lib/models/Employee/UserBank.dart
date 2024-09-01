class UserBank {
  late int id;
  late String name;
  late String number;
  late String holder_name;

  UserBank({
    required this.id,
    required this.name,
    required this.number,
    required this.holder_name,
  });

  UserBank.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    number = json['number'] ?? "";
    holder_name = json['holder_name'] ?? "";
  }
}