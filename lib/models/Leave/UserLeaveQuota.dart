class UserLeaveQuota {
  late int quotas;
  late int expired_date;
  late int received_at;

  UserLeaveQuota({
    required this.quotas,
    required this.expired_date,
    required this.received_at,
  });

  UserLeaveQuota.fromJson(Map<String, dynamic> json) {
    quotas = json["quotas"] ?? 0; 
    expired_date = json["expired_date"] ?? 0; 
    received_at = json["received_at"] ?? 0;
  }
}