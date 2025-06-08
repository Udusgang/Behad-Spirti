import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppHelpers.hexToColor(category.color);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              categoryColor.withOpacity(0.95),
              categoryColor.withOpacity(0.8),
              AppTheme.deepSpace.withOpacity(0.9),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(
            color: AppTheme.accentGold.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withOpacity(0.6),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppTheme.accentGold.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
            // Add inner glow effect
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 1),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cosmic icon with enhanced glow effect
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.accentGold.withOpacity(0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentGold.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color: AppTheme.accentGold.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  _getCategoryIcon(category.id),
                  color: AppTheme.starWhite,
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  category.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.95),
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${category.courseIds.length} courses',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white60,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    // Cosmic-themed icons based on category names/IDs
    if (categoryId.toLowerCase().contains('cosmic') || categoryId.toLowerCase().contains('creation')) {
      return Icons.public; // Universe/globe
    } else if (categoryId.toLowerCase().contains('stellar') || categoryId.toLowerCase().contains('star')) {
      return Icons.star; // Stars
    } else if (categoryId.toLowerCase().contains('divine') || categoryId.toLowerCase().contains('mystery')) {
      return Icons.auto_awesome; // Divine/mystical
    } else if (categoryId.toLowerCase().contains('consciousness') || categoryId.toLowerCase().contains('universal')) {
      return Icons.psychology; // Consciousness
    } else if (categoryId.toLowerCase().contains('galaxy')) {
      return Icons.blur_circular; // Galaxy
    } else if (categoryId.toLowerCase().contains('meditation')) {
      return Icons.self_improvement; // Meditation
    } else {
      return Icons.explore; // Default cosmic exploration
    }
  }
}
