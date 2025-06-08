import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingParticles extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final double particleSize;
  final Color particleColor;

  const FloatingParticles({
    super.key,
    required this.child,
    this.particleCount = 50,
    this.particleSize = 2.0,
    this.particleColor = const Color(0xFFFFD700),
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    
    _generateParticles();
  }

  void _generateParticles() {
    final random = math.Random();
    _particles = List.generate(widget.particleCount, (index) {
      return Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * widget.particleSize + 0.5,
        speed: random.nextDouble() * 0.5 + 0.1,
        opacity: random.nextDouble() * 0.6 + 0.2,
        direction: random.nextDouble() * 2 * math.pi,
        pulseSpeed: random.nextDouble() * 2 + 1,
      );
    });
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
        widget.child,
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  particles: _particles,
                  animationValue: _controller.value,
                  color: widget.particleColor,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
      ],
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Calculate particle position with floating movement
      final time = animationValue * particle.speed;
      final x = (particle.x + math.sin(time * 2 * math.pi + particle.direction) * 0.1) * size.width;
      final y = (particle.y + math.cos(time * 2 * math.pi + particle.direction) * 0.05) * size.height;
      
      // Wrap around screen edges
      final wrappedX = x % size.width;
      final wrappedY = y % size.height;
      
      // Calculate pulsing opacity
      final pulseOpacity = particle.opacity * 
          (0.5 + 0.5 * math.sin(animationValue * particle.pulseSpeed * 2 * math.pi));
      
      final paint = Paint()
        ..color = color.withOpacity(pulseOpacity)
        ..style = PaintingStyle.fill;
      
      // Draw particle
      canvas.drawCircle(
        Offset(wrappedX, wrappedY),
        particle.size,
        paint,
      );
      
      // Add glow effect for larger particles
      if (particle.size > 1.5) {
        final glowPaint = Paint()
          ..color = color.withOpacity(pulseOpacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        
        canvas.drawCircle(
          Offset(wrappedX, wrappedY),
          particle.size * 2,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final double direction;
  final double pulseSpeed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.direction,
    required this.pulseSpeed,
  });
}
