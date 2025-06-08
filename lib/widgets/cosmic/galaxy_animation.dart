import 'package:flutter/material.dart';
import 'dart:math' as math;

class GalaxyAnimation extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  const GalaxyAnimation({
    super.key,
    this.size = 200,
    this.primaryColor = const Color(0xFF4C1D95),
    this.secondaryColor = const Color(0xFFFFD700),
  });

  @override
  State<GalaxyAnimation> createState() => _GalaxyAnimationState();
}

class _GalaxyAnimationState extends State<GalaxyAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationController, _pulseController]),
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationController.value * 2 * math.pi,
            child: CustomPaint(
              painter: GalaxyPainter(
                rotationValue: _rotationController.value,
                pulseValue: _pulseController.value,
                primaryColor: widget.primaryColor,
                secondaryColor: widget.secondaryColor,
              ),
              size: Size(widget.size, widget.size),
            ),
          );
        },
      ),
    );
  }
}

class GalaxyPainter extends CustomPainter {
  final double rotationValue;
  final double pulseValue;
  final Color primaryColor;
  final Color secondaryColor;

  GalaxyPainter({
    required this.rotationValue,
    required this.pulseValue,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw galaxy core
    _drawGalaxyCore(canvas, center, radius);
    
    // Draw spiral arms
    _drawSpiralArms(canvas, center, radius);
    
    // Draw outer glow
    _drawOuterGlow(canvas, center, radius);
  }

  void _drawGalaxyCore(Canvas canvas, Offset center, double radius) {
    final coreRadius = radius * 0.15 * (1 + pulseValue * 0.3);
    
    // Core glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          secondaryColor.withOpacity(0.8),
          secondaryColor.withOpacity(0.4),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: coreRadius * 2));
    
    canvas.drawCircle(center, coreRadius * 2, glowPaint);
    
    // Core
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          secondaryColor,
          primaryColor,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: coreRadius));
    
    canvas.drawCircle(center, coreRadius, corePaint);
  }

  void _drawSpiralArms(Canvas canvas, Offset center, double radius) {
    final armPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    // Draw multiple spiral arms
    for (int arm = 0; arm < 4; arm++) {
      final armOffset = (arm * math.pi / 2) + (rotationValue * 2 * math.pi);
      
      final path = Path();
      bool firstPoint = true;
      
      for (double t = 0; t < 4 * math.pi; t += 0.1) {
        final spiralRadius = radius * 0.2 + (t / (4 * math.pi)) * radius * 0.6;
        final angle = t + armOffset;
        
        final x = center.dx + spiralRadius * math.cos(angle);
        final y = center.dy + spiralRadius * math.sin(angle);
        
        if (firstPoint) {
          path.moveTo(x, y);
          firstPoint = false;
        } else {
          path.lineTo(x, y);
        }
      }
      
      // Gradient along the spiral
      final opacity = 0.6 - (arm * 0.1);
      armPaint.color = primaryColor.withOpacity(opacity);
      canvas.drawPath(path, armPaint);
    }
  }

  void _drawOuterGlow(Canvas canvas, Offset center, double radius) {
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withOpacity(0.3),
          primaryColor.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawCircle(center, radius, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
