import 'TaxStatus.dart';

class UserTax {
  late int id;
  late String npwp;
  late String ptkp_status;
  late String tax_method;
  late String tax_salary;
  late String taxable_date;
  late String beginning_netto;
  late String pph21_paid;
  late TaxStatus taxStatus;

  UserTax({
    required this.id,
    required this.npwp,
    required this.ptkp_status,
    required this.tax_method,
    required this.tax_salary,
    required this.taxable_date,
    required this.beginning_netto,
    required this.pph21_paid,
    required this.taxStatus,
  });

  UserTax.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    npwp = json['npwp'] ?? "";
    ptkp_status = json['ptkp_status'] ?? "";
    tax_method = json['tax_method'] ?? "";
    tax_salary = json['tax_salary'] ?? "";
    taxable_date = json['taxable_date'] ?? "";
    beginning_netto = json['beginning_netto'] ?? "";
    pph21_paid = json['pph21_paid'] ?? "";
    taxStatus = TaxStatus.fromJson(json['tax_status'] ?? {});
  }
}