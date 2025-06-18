import 'package:flutter/material.dart';
import 'edit_recipe_page.dart';
import '../models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_recipes_app/pages/home_page.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(recipe.ingredients, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(recipe.instructions, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => EditRecipePage(
                              recipeId: recipe.id,
                              currentTitle: recipe.title,
                              currentIngredients: recipe.ingredients,
                              currentInstructions: recipe.instructions,
                            ),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text('Edit'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Delete recipe'),
                            content: const Text(
                              'Are you sure you want to delete this recipe?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                    );

                    if (shouldDelete == true) {
                      try {
                        await FirebaseFirestore.instance
                            .collection('recipes')
                            .doc(recipe.id)
                            .delete();

                        if (!context.mounted) return;

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (route) => false,
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error while deleting: $e')),
                        );
                      }
                    }
                  },

                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
