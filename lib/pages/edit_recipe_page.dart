import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_recipes_app/pages/home_page.dart';


class EditRecipePage extends StatefulWidget {
  final String recipeId;
  final String currentTitle;
  final String currentIngredients;
  final String currentInstructions;

  const EditRecipePage({
    super.key,
    required this.recipeId,
    required this.currentTitle,
    required this.currentIngredients,
    required this.currentInstructions,
  });

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  late TextEditingController _titleController;
  late TextEditingController _ingredientsController;
  late TextEditingController _instructionsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _ingredientsController = TextEditingController(text: widget.currentIngredients);
    _instructionsController = TextEditingController(text: widget.currentInstructions);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _updateRecipe() async {
    try {
      await FirebaseFirestore.instance.collection('recipes').doc(widget.recipeId).update({
        'title': _titleController.text.trim(),
        'ingredients': _ingredientsController.text.trim(),
        'instructions': _instructionsController.text.trim(),
      });

      print('Recipe updated');

     if (!mounted) return; 
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
     // Вернуться назад после сохранения
    } catch (e) {
      print('Error during update: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during update: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(labelText: 'Ingredients'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(labelText: 'Instructions'),
              maxLines: 6,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateRecipe,
              child: const Text('Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}
