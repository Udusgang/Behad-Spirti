import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class AlmightyLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;
  final bool animated;

  const AlmightyLogo({
    super.key,
    this.size = 120,
    this.showText = true,
    this.textColor,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    if (animated) {
      return _AnimatedLogo(
        size: size,
        showText: showText,
        textColor: textColor,
      );
    }
    
    return _StaticLogo(
      size: size,
      showText: showText,
      textColor: textColor,
    );
  }
}

class _StaticLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const _StaticLogo({
    required this.size,
    required this.showText,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Symbol
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [
                Color(0xFFFFD700), // Gold center
                Color(0xFFB8860B), // Dark gold
                Color(0xFF6B46C1), // Purple edge
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.amber.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Container(
                width: size * 0.9,
                height: size * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
              
              // Inner divine symbol
              Icon(
                Icons.auto_awesome,
                size: size * 0.4,
                color: Colors.white,
              ),
              
              // Crown symbol on top
              Positioned(
                top: size * 0.15,
                child: Icon(
                  Icons.diamond,
                  size: size * 0.15,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              
              // Sacred geometry lines
              CustomPaint(
                size: Size(size * 0.8, size * 0.8),
                painter: SacredGeometryPainter(),
              ),
            ],
          ),
        ),
        
        if (showText) ...[
          const SizedBox(height: 16),
          // App Name
          Text(
            'ALMIGHTY',
            style: TextStyle(
              fontSize: size * 0.15,
              fontWeight: FontWeight.w900,
              color: textColor ?? AppTheme.primaryPurple,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          Text(
            'AUTHORITY',
            style: TextStyle(
              fontSize: size * 0.12,
              fontWeight: FontWeight.w700,
              color: (textColor ?? AppTheme.primaryPurple).withOpacity(0.8),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Divine Wisdom • Spiritual Growth',
            style: TextStyle(
              fontSize: size * 0.08,
              fontWeight: FontWeight.w400,
              color: (textColor ?? AppTheme.mediumGray).withOpacity(0.7),
              letterSpacing: 0.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const _AnimatedLogo({
    required this.size,
    required this.showText,
    this.textColor,
  });

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: _StaticLogo(
              size: widget.size,
              showText: widget.showText,
              textColor: widget.textColor,
            ),
          ),
        );
      },
    );
  }
}

class SacredGeometryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw sacred geometry pattern
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (3.14159 / 180);
      final x = center.dx + radius * 0.7 * math.cos(angle);
      final y = center.dy + radius * 0.7 * math.sin(angle);
      
      canvas.drawLine(center, Offset(x, y), paint);
    }
    
    // Draw inner circle
    canvas.drawCircle(center, radius * 0.3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
