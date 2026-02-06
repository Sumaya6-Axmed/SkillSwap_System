class SkillModel {
  final String id;
  final String name;
  final String category;
  final String? description;

  // creator can be string id OR object with name (because populate("creator","name")) :contentReference[oaicite:7]{index=7}
  final dynamic creator;

  SkillModel({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.creator,
  });

  String get creatorName {
    if (creator is Map && (creator as Map).containsKey("name")) {
      return (creator as Map)["name"]?.toString() ?? "Unknown";
    }
    return "Unknown";
  }

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json["_id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      category: json["category"]?.toString() ?? "",
      description: json["description"]?.toString(),
      creator: json["creator"],
    );
  }

  Map<String, dynamic> toCreateJson() => {
    "name": name,
    "category": category,
    "description": description ?? "",
  };
}
