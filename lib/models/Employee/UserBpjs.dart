class UserBpjs {
  late int id;
  late String ketenagakerjaan_number;
  late String ketenagakerjaan_npp;
  late String ketenagakerjaan_date;
  late String kesehatan_number;
  late String kesehatan_family;
  late String kesehatan_date;
  late String kesehatan_cost;
  late String jht_cost;
  late String jaminan_pensiun_cost;
  late String jaminan_pensiun_date;

  UserBpjs({
    required this.id,
    required this.ketenagakerjaan_number,
    required this.ketenagakerjaan_npp,
    required this.ketenagakerjaan_date,
    required this.kesehatan_number,
    required this.kesehatan_family,
    required this.kesehatan_date,
    required this.kesehatan_cost,
    required this.jht_cost,
    required this.jaminan_pensiun_cost,
    required this.jaminan_pensiun_date,
  });

  UserBpjs.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    ketenagakerjaan_number = json['ketenagakerjaan_number'] ?? "";
    ketenagakerjaan_npp = json['ketenagakerjaan_npp'] ?? "";
    ketenagakerjaan_date = json['ketenagakerjaan_date'] ?? "";
    kesehatan_number = json['kesehatan_number'] ?? "";
    kesehatan_family = json['kesehatan_family'] ?? "";
    kesehatan_date = json['kesehatan_date'] ?? "";
    kesehatan_cost = json['kesehatan_cost'] ?? "";
    jht_cost = json['jht_cost'] ?? "";
    jaminan_pensiun_cost = json['jaminan_pensiun_cost'] ?? "";
    jaminan_pensiun_date = json['jaminan_pensiun_date'] ?? "";
  }
}