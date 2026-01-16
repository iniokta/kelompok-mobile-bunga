class Recipe {
  final String id;
  final String title;
  final String category;
  final int timeMinutes;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.timeMinutes,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    this.createdAt,
    this.updatedAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: (json["id"] ?? "").toString(),
      title: (json["title"] ?? "").toString(),
      category: (json["category"] ?? "").toString(),
      timeMinutes: (json["timeMinutes"] ?? 0) is int
          ? json["timeMinutes"]
          : int.tryParse(json["timeMinutes"].toString()) ?? 0,
      imageUrl: (json["imageUrl"] ?? "").toString(),
      ingredients: (json["ingredients"] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      steps: (json["steps"] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString())
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"].toString())
          : null,
    );
  }

  Map<String, dynamic> toJsonForCreateUpdate() {
    return {
      "title": title,
      "category": category,
      "timeMinutes": timeMinutes,
      "imageUrl": imageUrl,
      "ingredients": ingredients,
      "steps": steps,
    };
  }

  Recipe copyWith({
    String? id,
    String? title,
    String? category,
    int? timeMinutes,
    String? imageUrl,
    List<String>? ingredients,
    List<String>? steps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      timeMinutes: timeMinutes ?? this.timeMinutes,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
