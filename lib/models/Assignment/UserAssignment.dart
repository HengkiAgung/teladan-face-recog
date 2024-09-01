import '../Employee/User.dart';

class UserAssignment {
  late int id;
  late int assignmentId;
  late int userId;
  late String? name;
  late String? position;
  late String? nik;
  late String? pdf;
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late User user;

  UserAssignment({
    required this.id,
    required this.assignmentId,
    required this.userId,
    this.name,
    this.position,
    this.nik,
    this.createdAt,
    this.updatedAt,
    this.pdf,
    required this.user,
  });

  UserAssignment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    assignmentId = json['assignment_id'] ?? 0;
    userId = json['user_id'] ?? 0;
    name = json['name'];
    position = json['position'];
    nik = json['nik'];
    pdf = json['pdf'];
    createdAt = DateTime.tryParse(json['created_at'] ?? "");
    updatedAt = DateTime.tryParse(json['updated_at'] ?? "");
    user = User.fromJson(json['user'] ?? {});
  }
}
