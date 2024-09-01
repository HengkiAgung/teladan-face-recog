class SubBranch {
  late int id;
  late String name;
  late String email;
  late String phone_number;
  late String city;
  late String province;
  late String address;
  late int umr;
  late String npwp;
  late String tax_name;
  late String tax_person_npwp;
  late String tax_person_name;
  late String klu;
  late String signature;
  late String logo;

  SubBranch({
    required this.id,
    required this.name,
    required this.email,
    required this.phone_number,
    required this.city,
    required this.province,
    required this.address,
    required this.umr,
    required this.npwp,
    required this.tax_name,
    required this.tax_person_npwp,
    required this.tax_person_name,
    required this.klu,
    required this.signature,
    required this.logo,
  });

  SubBranch.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    phone_number = json['phone_number'] ?? "";
    city = json['city'] ?? "";
    province = json['province'] ?? "";
    address = json['address'] ?? "";
    umr = json['umr'] ?? 0;
    npwp = json['npwp'] ?? "";
    tax_name = json['tax_name'] ?? "";
    tax_person_npwp = json['tax_person_npwp'] ?? "";
    tax_person_name = json['tax_person_name'] ?? "";
    klu = json['klu'] ?? "";
    signature = json['signature'] ?? "";
    logo = json['logo'] ?? "";
  }
}