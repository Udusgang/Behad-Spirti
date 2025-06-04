import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import 'course_card.dart';

class FeaturedSection extends StatelessWidget {
  final String title;
  final List<Course> courses;
  final Function(Course) onCourseTap;

  const FeaturedSection({
    super.key,
    required this.title,
    required this.courses,
    required this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to see all featured courses
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: courses.length,
              separatorBuilder: (context, index) => const SizedBox(
                width: AppConstants.defaultPadding,
              ),
              itemBuilder: (context, index) {
                final course = courses[index];
                return SizedBox(
                  width: 200,
                  child: CourseCard(
                    course: course,
                    onTap: () => onCourseTap(course),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
