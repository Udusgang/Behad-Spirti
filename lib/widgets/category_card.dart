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
              categoryColor.withOpacity(0.9),
              categoryColor.withOpacity(0.7),
              AppTheme.deepSpace.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.accentGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _getCategoryIcon(category.id),
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                category.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
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
