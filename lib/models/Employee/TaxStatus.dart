class TaxStatus {
  late int id;
  late String name;

  TaxStatus({
    required this.id,
    required this.name,
  });

  TaxStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
  }
}