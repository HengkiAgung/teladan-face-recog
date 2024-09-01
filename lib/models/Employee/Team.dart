class Team {
  late int id;
  late String team_name;

  Team({
    required this.id,
    required this.team_name,
  });

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    team_name = json['team_name'] ?? "";
  }
}