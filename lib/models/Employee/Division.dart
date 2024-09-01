class Division {
  late int id;
  late String divisi_name;
  late String divisi_alias;

  Division({
    required this.id,
    required this.divisi_name,
    required this.divisi_alias,
  });

  Division.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    divisi_name = json['divisi_name'] ?? "";
    divisi_alias = json['divisi_alias'] ?? "";
  }
}