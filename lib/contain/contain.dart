import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../recipe/opor-ayam-Kampung.dart';

// Recipe model to hold parsed data
class Recipe {
  final String title;
  final String image;
  final String time;
  final String level;
  final String calories;
  final List<String> ingredients;
  final List<String> directions;
  final String author;
  final String rate;

  Recipe({
    required this.title,
    required this.image,
    required this.time,
    required this.level,
    required this.calories,
    required this.ingredients,
    required this.directions,
    required this.author,
    required this.rate,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Parse ingredients and directions from markdown string
    List<String> ingredients = [];
    List<String> directions = [];
    String author = '';
    String rate = '';

    String descriptionMarkdown = json['description_markdown'] ?? '';
    final lines = descriptionMarkdown.split('\n');

    bool inIngredients = false;
    bool inDirections = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.startsWith('dari ')) {
        author = line.substring(5).trim();
        continue;
      }

      if (line == '## Bahan-Bahan') {
        inIngredients = true;
        inDirections = false;
        continue;
      } else if (line == '## Cara Membuat') {
        inIngredients = false;
        inDirections = true;
        continue;
      } else if (line.startsWith('##') || line.startsWith('#')) {
        inIngredients = false;
        inDirections = false;
        continue;
      }

      if (inIngredients && line.startsWith('- **')) {
        String ingredient = line.substring(2).trim();
        ingredient = ingredient.replaceAll('**', '');
        ingredients.add(ingredient);
      }

      if (inDirections && line.isNotEmpty && !line.startsWith('#')) {
        if (RegExp(r'^\d+\.').hasMatch(line)) {
          String direction = line.substring(line.indexOf('.') + 1).trim();
          directions.add(direction);
        }
      }
    }

    return Recipe(
      title: json['title'] ?? 'Unknown Recipe',
      image: json['image'] ?? 'assets/images/default.jpg',
      time: json['time'] ?? '0',
      level: json['level'] ?? 'Unknown',
      calories: json['cal'] ?? '0',
      ingredients: ingredients,
      directions: directions,
      author: author.isNotEmpty ? author : 'Unknown',
      rate: json['rate'] ?? '0.0',
    );
  }
}

class RecipeContainer {
  static Future<Recipe> loadRecipeFromJson(String fileName) async {
    try {
      if (fileName == 'opor-ayam-Kampung.json') {
        return Recipe.fromJson(oporAyam.toJson());
      } else {
        String content = await rootBundle.loadString('assets/recipe/$fileName');
        Map<String, dynamic> json = jsonDecode(content);
        return Recipe.fromJson(json);
      }
    } catch (e) {
      throw Exception('Failed to load recipe: $e');
    }
  }
}

// Updated RecipeDetailScreen that uses dynamic data
class RecipeDetailScreen extends StatefulWidget {
  final String? recipeFileName;

  const RecipeDetailScreen({super.key, this.recipeFileName});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Recipe? recipe;
  bool isLoading = true;
  String? error;
  String? recipeFileName;

  @override
  void initState() {
    super.initState();
    // Will be set in didChangeDependencies when ModalRoute is available
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the filename from route arguments or use the widget parameter
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    recipeFileName =
        args?['recipeFileName'] as String? ??
        widget.recipeFileName ??
        'opor-ayam-Kampung.json'; // Default fallback

    if (recipe == null && !isLoading) {
      _loadRecipe();
    } else if (recipe == null) {
      _loadRecipe();
    }
  }

  Future<void> _loadRecipe() async {
    if (recipeFileName == null) {
      setState(() {
        error = 'No recipe file specified';
        isLoading = false;
      });
      return;
    }

    try {
      final loadedRecipe = await RecipeContainer.loadRecipeFromJson(
        recipeFileName!,
      );
      setState(() {
        recipe = loadedRecipe;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Error loading recipe: $error'),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (recipe == null) {
      return Scaffold(body: Center(child: Text('No recipe data found')));
    }

    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                // Top image section with curved bottom
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: ClipPath(
                    clipper: CurvedBottomClipper(),
                    child: Image.asset(
                      recipe!.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.image_not_supported, size: 64),
                        );
                      },
                    ),
                  ),
                ),

                // White container with recipe details
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recipe title
                          Text(
                            recipe!.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (recipe!.author.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Text(
                              'oleh ${recipe!.author}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),

                          // Three info boxes
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Time box
                              _buildInfoBox(
                                color: const Color(0xFFD4F5E9),
                                icon: Icons.access_time,
                                iconColor: Colors.green,
                                text: '${recipe!.time} MIN',
                              ),

                              // Difficulty box
                              _buildInfoBox(
                                color: const Color(0xFFFFF3D8),
                                icon: Icons.sentiment_satisfied,
                                iconColor: Colors.orange,
                                text: recipe!.level.toUpperCase(),
                              ),

                              // Calories box
                              _buildInfoBox(
                                color: const Color(0xFFE6F0FF),
                                icon: Icons.local_fire_department,
                                iconColor: Colors.blue,
                                text: '${recipe!.calories} cal/serving',
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // Ingredients section
                          const Text(
                            'Ingredients :',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Dynamic ingredients list
                          ...recipe!.ingredients
                              .map(
                                (ingredient) =>
                                    _buildIngredientItem(ingredient),
                              )
                              .toList(),
                          const SizedBox(height: 25),

                          // Directions section
                          const Text(
                            'Directions :',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Dynamic directions list
                          ...recipe!.directions
                              .asMap()
                              .entries
                              .map(
                                (entry) => _buildDirectionStep(
                                  entry.key + 1,
                                  entry.value,
                                ),
                              )
                              .toList(),
                          const SizedBox(height: 50), // Extra space at bottom
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // Bookmark button
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.bookmark_border, color: Colors.black),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build info boxes
  Widget _buildInfoBox({
    required Color color,
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(color: iconColor, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper method to build ingredient items
  Widget _buildIngredientItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 10),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  // Helper method to build direction steps
  Widget _buildDirectionStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 25,
            height: 25,
            margin: const EdgeInsets.only(right: 10, top: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

// Custom clipper for curved bottom edge of image
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
