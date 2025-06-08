import 'package:flutter/material.dart';
import 'dart:math' as math;

class StarfieldBackground extends StatefulWidget {
  final Widget child;
  final int starCount;
  final double animationSpeed;

  const StarfieldBackground({
    super.key,
    required this.child,
    this.starCount = 100,
    this.animationSpeed = 1.0,
  });

  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _generateStars();
  }

  void _generateStars() {
    final random = math.Random();
    _stars = List.generate(widget.starCount, (index) {
      return Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        opacity: random.nextDouble() * 0.8 + 0.2,
        twinkleSpeed: random.nextDouble() * 2 + 1,
        color: _getStarColor(random),
      );
    });
  }

  Color _getStarColor(math.Random random) {
    final colors = [
      Colors.white,
      const Color(0xFFFFD700), // Gold
      const Color(0xFFC0C0C0), // Silver
      const Color(0xFF87CEEB), // Sky blue
      const Color(0xFFDDA0DD), // Plum
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cosmic background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF000814),
                Color(0xFF001D3D),
                Color(0xFF003566),
                Color(0xFF0077B6),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        ),
        // Animated stars
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: StarfieldPainter(_stars, _controller.value),
              size: Size.infinite,
            );
          },
        ),
        // Child content
        widget.child,
      ],
    );
  }
}

class StarfieldPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarfieldPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final paint = Paint()
        ..color = star.color.withOpacity(
          star.opacity * (0.5 + 0.5 * math.sin(animationValue * star.twinkleSpeed * 2 * math.pi)),
        )
        ..style = PaintingStyle.fill;

      final x = star.x * size.width;
      final y = star.y * size.height;
      
      // Draw star with twinkling effect
      canvas.drawCircle(
        Offset(x, y),
        star.size * (0.8 + 0.2 * math.sin(animationValue * star.twinkleSpeed * 2 * math.pi)),
        paint,
      );
      
      // Add star glow effect for larger stars
      if (star.size > 2) {
        final glowPaint = Paint()
          ..color = star.color.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
        
        canvas.drawCircle(
          Offset(x, y),
          star.size * 2,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double twinkleSpeed;
  final Color color;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
    required this.color,
  });
}
