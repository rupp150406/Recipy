import 'package:flutter/material.dart';
import '../route/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set scaffold background to white
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/navbar.png',
                        width: 45,
                        height: 45,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'What would you like\nto Cook?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              // Search Box
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    hintText: 'Search for your query',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),

              // Today Recipe Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Today recipe',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // Today Recipe Cards - Horizontal Scroll
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      RecipeDisplayCard(
                        image: 'assets/images/opor-ayam-Kampung.jpg',
                        title: 'Opor Ayam Kampung',
                        time: '15 M',
                        level: 'EASY',
                        rate: '5.0',
                        onTap: () {
                          NavigationHelper.navigateToRecipe(
                            context,
                            'opor-ayam-Kampung.json',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Recommended Section Header
              const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'See All',
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ],
                ),
              ),

              // Recommended Recipe Card - Centered
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RecipeDisplayCard(
                  image: 'assets/images/opor-ayam-Kampung.jpg',
                  title: 'Opor Ayam Kampung',
                  time: '15 M',
                  level: 'EASY',
                  rate: '5.0',
                  onTap: () {
                    NavigationHelper.navigateToRecipe(
                      context,
                      'opor-ayam-Kampung.json',
                    );
                  },
                  isRecommended: true,
                  author: 'By jeng hayoone',
                  badgeText: 'NEW',
                  badgeColor: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeDisplayCard extends StatelessWidget {
  final String image;
  final String title;
  final String time;
  final String level;
  final String rate;
  final VoidCallback onTap;
  final bool isRecommended;
  final String? author;
  final String? badgeText;
  final Color? badgeColor;

  const RecipeDisplayCard({
    super.key,
    required this.image,
    required this.title,
    required this.time,
    required this.level,
    required this.rate,
    required this.onTap,
    this.isRecommended = false,
    this.author,
    this.badgeText,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isRecommended ? _buildRecommendedCard() : _buildRecipeCard(),
    );
  }

  Widget _buildRecipeCard() {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 64),
                );
              },
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    time,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    level,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 10, color: Colors.white),
                  const SizedBox(width: 2),
                  Text(
                    rate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image with badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
              if (badgeText != null)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor ?? Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badgeText!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (author != null)
                  Text(
                    author!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        level == 'EASY'
                            ? Icon(
                              Icons.sentiment_satisfied,
                              size: 14,
                              color: Colors.grey[600],
                            )
                            : Icon(
                              Icons.local_fire_department,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                        const SizedBox(width: 4),
                        Text(
                          level,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Rating
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.white),
                const SizedBox(width: 2),
                Text(
                  rate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
