import 'Department.dart';
import 'Division.dart';
import 'Role.dart';
import 'Team.dart';
import 'UserEmployment.dart';
import 'UserPersonalData.dart';

class User {
  late int id;
  late String name;
  late String email;
  late String signFile;
  late bool is_new;
  late String kontak;
  late int status;
  late String foto_file;
  late String nip;
  late String nik;
  late Team? team;
  late List<Role>? roles;
  late Division? division;
  late Department? department;
  late UserPersonalData? userPersonalData;
  late UserEmployment? userEmployment;

  User({
    required this.id,
    required this.name,
    required this.nip,
    required this.nik,
    required this.email,
    required this.is_new,
    required this.signFile,
    required this.kontak,
    required this.status,
    required this.foto_file,
    required this.userPersonalData,
    required this.team,
    required this.roles,
    required this.division,
    required this.department,
    required this.userEmployment,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    nip = json['nip'] ?? "";
    nik = json['nik'] ?? "";
    is_new = json['is_new'] == 0 || json['is_new'] == "0" ? false : true;
    email = json['email'] ?? "";
    signFile = json['signFile'] ?? "";
    kontak = json['kontak'] ?? "";
    status = json['status'] ?? 0;
    foto_file = json['foto_file'] ?? "";
    userPersonalData = json['user_personal_data'] != null
        ? UserPersonalData.fromJson(json['user_personal_data'])
        : null;
    team = json['team'] != null ? Team.fromJson(json['team']) : null;
    division =
        json['division'] != null ? Division.fromJson(json['division']) : null;
    department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
    userEmployment = json['user_employment'] != null
        ? UserEmployment.fromJson(json['user_employment'])
        : null;

    Iterable it = json['roles'] ?? [];
    roles = it.map((e) {
      var role = Role.fromJson(e);
      return role;
    }).toList();
  }
}
