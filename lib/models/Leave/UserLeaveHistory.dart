class UserLeaveHistory {
  late String type;
  late String name;
  late String approval_name;
  late String date;
  late int quota_change;

  UserLeaveHistory({
    required this.type,
    required this.name,
    required this.approval_name,
    required this.date,
    required this.quota_change,
  });

  UserLeaveHistory.fromJson(Map<String, dynamic> json) {
    type = json["type"] ?? ""; 
    name = json["name"] ?? ""; 
    approval_name = json["approval_name"] ?? ""; 
    date = json["date"] ?? ""; 
    quota_change = json["quota_change"] ?? 0;
  }
}