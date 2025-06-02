import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _ingredients = '';
  String _instructions = '';

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save to Firestore
      await FirebaseFirestore.instance.collection('recipes').add({
        'title': _title,
        'ingredients': _ingredients,
        'instructions': _instructions,
        'createdAt': Timestamp.now(),
      });

      // Save to history
      await FirebaseFirestore.instance.collection('history').add({
        'title': _title,
        'action': 'created',
        'timestamp': Timestamp.now(),
      });

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),

              // Ingredients
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ingredients'),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter ingredients' : null,
                onSaved: (value) => _ingredients = value!,
              ),
              const SizedBox(height: 16),

              // Instructions
              TextFormField(
                decoration: const InputDecoration(labelText: 'Instructions'),
                maxLines: 6,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter instructions' : null,
                onSaved: (value) => _instructions = value!,
              ),
              const SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: _saveRecipe,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
