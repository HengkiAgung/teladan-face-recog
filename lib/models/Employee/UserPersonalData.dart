class UserPersonalData {
  late int id;
  late String birthdate;
  late String place_of_birth;
  late String marital_status;
  late String gender;
  late String blood_type;
  late String religion;

  UserPersonalData({
    required this.id,
    required this.birthdate,
    required this.place_of_birth,
    required this.marital_status,
    required this.gender,
    required this.blood_type,
    required this.religion,
  });

  UserPersonalData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    birthdate = json['birthdate'] ?? "";
    place_of_birth = json['place_of_birth'] ?? "";
    marital_status = json['marital_status'] ?? "";
    gender = json['gender'] ?? "";
    blood_type = json['blood_type'] ?? "";
    religion = json['religion'] ?? "";
  }
}