class Recipe {
  final String id;
  final String title;
  final String ingredients;
  final String instructions;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
  });

  factory Recipe.fromMap(String id, Map<String, dynamic> data) {
    return Recipe(
      id: id,
      title: data['title'] ?? '',
      ingredients: data['ingredients'] ?? '',
      instructions: data['instructions'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'isFavorite': isFavorite,
    };
  }
}
