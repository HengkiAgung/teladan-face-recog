class UserTimeOfRequest {
  late int id;

  UserTimeOfRequest({
    required this.id,
  });

  UserTimeOfRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
  }
}