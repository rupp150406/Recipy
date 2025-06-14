import 'package:flutter/material.dart';
import '../contain/contain.dart';
import '../home/home_screen.dart';
import '../splash/splash_screen.dart';

class AppRoutes {
  // Route names as constants
  static const String splash = '/';
  static const String home = '/home';
  static const String recipeDetail = '/recipe-detail';

  // Route generator
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      home: (context) => const HomeScreen(),
      recipeDetail: (context) => const RecipeDetailScreen(),
    };
  }

  // Alternative: Use onGenerateRoute for more flexible routing
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case recipeDetail:
        // Extract arguments for recipe detail
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => const RecipeDetailScreen(),
          settings:
              settings, // Pass settings so RecipeDetailScreen can access arguments
        );

      default:
        return null;
    }
  }
}

// Helper class for navigation with arguments
class NavigationHelper {
  static void navigateToRecipe(BuildContext context, String recipeFileName) {
    Navigator.pushNamed(
      context,
      AppRoutes.recipeDetail,
      arguments: {'recipeFileName': recipeFileName},
    );
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  static void navigateToSplash(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.splash,
      (route) => false,
    );
  }
}
