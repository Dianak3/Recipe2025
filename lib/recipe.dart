class Recipe {
  final String id;
  final String title;
  final String ingredients;
  final String instructions;
  

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromMap(String id, Map<String, dynamic> data) {
    return Recipe(
      id: id,
      title: data['title'] ?? '',
      ingredients: data['ingredients'] ?? '',
      instructions: data['instructions'] ?? '',
    );
  }
   Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }
}