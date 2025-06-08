import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/category_card.dart';
import '../widgets/course_card.dart';
import '../widgets/featured_section.dart';
import '../widgets/cosmic/starfield_background.dart';
import '../widgets/cosmic/floating_particles.dart';
import '../widgets/cosmic/galaxy_animation.dart';
import 'course_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 80,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<CourseProvider>().refreshData();
            },
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
                _buildSearchBar(),
                _buildFeaturedSection(),
                _buildCategoriesSection(),
                _buildRecentCoursesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.galaxyGradient,
          ),
          child: Stack(
            children: [
              // Animated background particles
              Positioned.fill(
                child: CustomPaint(
                  painter: HeaderParticlesPainter(),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cosmic logo and title
                    Row(
                      children: [
                        const GalaxyAnimation(
                          size: 50,
                          primaryColor: Color(0xFFFFD700),
                          secondaryColor: Color(0xFFC0C0C0),
                        ),
                        const SizedBox(width: 12),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [AppTheme.starWhite, AppTheme.accentGold],
                          ).createShader(bounds),
                          child: const Text(
                            'Almighty Authority',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore the cosmic mysteries of creation',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.starWhite.withOpacity(0.9),
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Universe • Galaxies • Divine wisdom • Supreme authority',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.cosmicSilver.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: AppConstants.searchPlaceholder,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    if (_searchQuery.isNotEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Consumer<DynamicCourseProvider>(
        builder: (context, courseProvider, child) {
          if (courseProvider.isLoading) {
            return const Padding(
              padding: EdgeInsets.all(AppConstants.defaultPadding),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (courseProvider.error != null) {
            return Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Center(
                child: Text(
                  courseProvider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final featuredCourses = courseProvider.getFeaturedCourses();
          
          return FeaturedSection(
            title: 'Featured Courses',
            courses: featuredCourses,
            onCourseTap: (course) => _navigateToCourseDetail(course),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return SliverToBoxAdapter(
      child: Consumer<DynamicCourseProvider>(
        builder: (context, courseProvider, child) {
          if (courseProvider.isLoading) {
            return const SizedBox.shrink();
          }

          final categories = courseProvider.categories;

          return Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.starWhite,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                if (categories.isEmpty)
                  _buildEmptyState()
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: AppHelpers.getGridCrossAxisCount(context),
                      crossAxisSpacing: AppConstants.defaultPadding,
                      mainAxisSpacing: AppConstants.defaultPadding,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryCard(
                        category: category,
                        onTap: () => _navigateToCategory(category),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentCoursesSection() {
    return SliverToBoxAdapter(
      child: Consumer<DynamicCourseProvider>(
        builder: (context, courseProvider, child) {
          if (courseProvider.isLoading) {
            return const SizedBox.shrink();
          }

          List<Course> coursesToShow;
          String sectionTitle;

          if (_searchQuery.isNotEmpty) {
            coursesToShow = courseProvider.searchCourses(_searchQuery);
            sectionTitle = 'Search Results';
          } else {
            coursesToShow = courseProvider.getRecentCourses();
            sectionTitle = 'Recent Courses';
          }

          if (coursesToShow.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      _searchQuery.isNotEmpty 
                          ? 'No courses found for "$_searchQuery"'
                          : AppConstants.noCoursesFound,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sectionTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppHelpers.getGridCrossAxisCount(context),
                    crossAxisSpacing: AppConstants.defaultPadding,
                    mainAxisSpacing: AppConstants.defaultPadding,
                    childAspectRatio: AppConstants.gridChildAspectRatio,
                  ),
                  itemCount: coursesToShow.length,
                  itemBuilder: (context, index) {
                    final course = coursesToShow[index];
                    return CourseCard(
                      course: course,
                      onTap: () => _navigateToCourseDetail(course),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToCourseDetail(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(course: course),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppTheme.accentGold.withOpacity(0.3),
                  AppTheme.primaryPurple.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.accentGold.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.explore,
              size: 60,
              color: AppTheme.accentGold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to the Cosmic Realm',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.starWhite,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'The universe awaits your exploration.\nContent will appear here once the cosmic admin adds categories and courses.',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.cosmicSilver.withOpacity(0.9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentGold.withOpacity(0.2),
                  AppTheme.primaryPurple.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppTheme.accentGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '✨ Coming Soon ✨',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentGold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCategory(Category category) {
    // For now, we'll show courses from this category
    // In the future, this could navigate to a dedicated category screen
    final courseProvider = context.read<DynamicCourseProvider>();
    final categoryCourses = courseProvider.getCoursesByCategory(category.id);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Text(
                  category.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: categoryCourses.length,
                  itemBuilder: (context, index) {
                    final course = categoryCourses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
                      child: CourseCard(
                        course: course,
                        onTap: () {
                          Navigator.pop(context);
                          _navigateToCourseDetail(course);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Create floating particles
    for (int i = 0; i < 20; i++) {
      final x = (i * 37.5) % size.width;
      final y = (i * 23.7) % size.height;
      final radius = (i % 3) + 1.0;

      paint.color = Colors.white.withOpacity(0.1 + (i % 3) * 0.05);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Add some larger glowing orbs
    for (int i = 0; i < 5; i++) {
      final x = (i * 80.0) % size.width;
      final y = (i * 60.0) % size.height;

      paint.color = Colors.white.withOpacity(0.05);
      canvas.drawCircle(Offset(x, y), 15, paint);

      paint.color = Colors.white.withOpacity(0.02);
      canvas.drawCircle(Offset(x, y), 25, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
