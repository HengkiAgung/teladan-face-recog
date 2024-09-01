class Summaries {
  late int onTimeCount;
  late int lateCheckInCount;
  late int earlyCheckOutCount;
  late int absent;
  late int noCheckInCount;
  late int noCheckOutCount;
  late int dayOffCount;
  late int timeOffCount;

  Summaries({
    required this.onTimeCount,
    required this.lateCheckInCount,
    required this.earlyCheckOutCount,
    required this.absent,
    required this.noCheckInCount,
    required this.noCheckOutCount,
    required this.dayOffCount,
    required this.timeOffCount,
  });

  Summaries.fromJson(Map<String, dynamic> json) {
    onTimeCount = json["onTimeCount"] ?? 0; 
    lateCheckInCount = json["lateCheckInCount"] ?? 0; 
    earlyCheckOutCount = json["earlyCheckOutCount"] ?? 0; 
    absent = json["absent"] ?? 0; 
    noCheckInCount = json["noCheckInCount"] ?? 0; 
    noCheckOutCount = json["noCheckOutCount"] ?? 0; 
    dayOffCount = json["dayOffCount"] ?? 0; 
    timeOffCount = json["timeOffCount"] ?? 0; 
  }
}