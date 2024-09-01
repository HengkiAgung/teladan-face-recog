class LeaveRequestCategory {
  
    late int id;
    late String name;
    late String code;
    late String effective_date;
    late String expired_date;
    late int attachment;
    late int show_in_request;
    late int? max_request;
    late int use_quota;
    late int min_notice;
    late int unlimited_balance;
    late int min_works;
    late int? balance;
    late String balance_type;
    late int expired;
    late int? carry_amount;
    late String? carry_expired;
    late int half_day;
    late int? minus_amount;
    late int? duration;

    LeaveRequestCategory({
      required this.id,
      required this.name,
      required this.code,
      required this.effective_date,
      required this.expired_date,
      required this.attachment,
      required this.show_in_request,
      required this.use_quota,
      required this.min_notice,
      required this.unlimited_balance,
      required this.min_works,
      required this.balance_type,
      required this.expired,
      required this.half_day,
    });

    LeaveRequestCategory.fromJson(Map<String, dynamic> json) {
      id = json['id'] ?? 0;
      name = json['name'] ?? "";
      code = json['code'] ?? "";
      effective_date = json['effective_date'] ?? "";
      expired_date = json['expired_date'] ?? "";
      attachment = json['attachment'] ?? 0;
      show_in_request = json['show_in_request'] ?? 0;
      max_request = json['max_request'];
      use_quota = json['use_quota'] ?? 0;
      min_notice = json['min_notice'] ?? 0;
      unlimited_balance = json['unlimited_balance'] ?? 0;
      min_works = json['min_works'] ?? 0;
      balance = json['balance'];
      balance_type = json['balance_type'] ?? "";
      expired = json['expired'] ?? 0;
      carry_amount = json['carry_amount'];
      carry_expired = json['carry_expired'];
      half_day = json['half_day'] ?? 0;
      minus_amount = json['minus_amount'];
      duration = json['duration'];
    }
  }
