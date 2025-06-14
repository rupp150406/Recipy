import 'package:flutter/material.dart';
import '../route/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top section with chef image and "25K+ PREMIUM RECIPES" text
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Center(
                    child: Image.asset(
                      'assets/images/chef.png',
                      height:
                          screenSize.height * 0.5, // Half of the screen height
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Add the "25K+ PREMIUM RECIPES" text in the top-left corner
                Positioned(
                  top: 20,
                  left: 20,
                  child: Text(
                    '25K+ PREMIUM RECIPES',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom section with left-aligned text and button
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align to the left
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // "It's Cooking Time!" text
                  const Text(
                    "It's\nCooking\nTime!",
                    textAlign: TextAlign.left, // Left align text
                    style: TextStyle(
                      fontSize: 45, // Increased font size
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // "Get Started" button
                  Align(
                    alignment:
                        Alignment.centerLeft, // Align the button to the left
                    child: SizedBox(
                      width: 200,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the main app screen
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(AppRoutes.home);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF57BA84,
                          ), // Updated green color
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
}
