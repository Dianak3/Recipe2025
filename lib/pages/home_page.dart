import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import 'recipe_detail_page.dart';
import 'add_recipe_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Book')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          }

          final recipes = docs.map((doc) => Recipe.fromMap(doc.id, doc.data()! as Map<String, dynamic>)).toList();

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                color: const Color(0xFFCFE0E4),
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(recipe.title),
                  subtitle: Text(
                    recipe.ingredients,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: recipe.isFavorite ? const Color(0xFF3CA3C0) : Colors.grey,
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('recipes')
                          .doc(recipe.id)
                          .update({'isFavorite': !recipe.isFavorite});
                    },
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailPage(recipe: recipe),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddRecipePage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}