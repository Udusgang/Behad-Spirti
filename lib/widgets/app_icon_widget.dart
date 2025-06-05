import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppIconWidget extends StatelessWidget {
  final double size;
  final bool forLauncher;

  const AppIconWidget({
    super.key,
    this.size = 120,
    this.forLauncher = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Color(0xFF4C1D95), // Dark purple
          ],
        ),
        borderRadius: forLauncher 
            ? BorderRadius.circular(size * 0.2) // Rounded corners for launcher
            : BorderRadius.circular(size * 0.5), // Circle for in-app
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.4),
            blurRadius: size * 0.2,
            offset: Offset(0, size * 0.05),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(
              borderRadius: forLauncher 
                  ? BorderRadius.circular(size * 0.18)
                  : BorderRadius.circular(size * 0.45),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: size * 0.01,
              ),
            ),
          ),
          
          // Main symbol
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Crown/Authority symbol
              Icon(
                Icons.diamond,
                size: size * 0.25,
                color: Colors.white,
              ),
              
              SizedBox(height: size * 0.02),
              
              // Text for launcher icon
              if (forLauncher) ...[
                Text(
                  'AA',
                  style: TextStyle(
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: size * 0.01,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, size * 0.01),
                        blurRadius: size * 0.02,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Divine symbol for in-app
                Icon(
                  Icons.auto_awesome,
                  size: size * 0.15,
                  color: Colors.white.withOpacity(0.9),
                ),
              ],
            ],
          ),
          
          // Sacred geometry overlay
          CustomPaint(
            size: Size(size * 0.8, size * 0.8),
            painter: IconGeometryPainter(size: size),
          ),
        ],
      ),
    );
  }
}

class IconGeometryPainter extends CustomPainter {
  final double size;

  IconGeometryPainter({required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = size * 0.005
      ..style = PaintingStyle.stroke;

    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final radius = canvasSize.width / 3;

    // Draw sacred geometry lines
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final x = center.dx + radius * 0.6 * (angle.cos());
      final y = center.dy + radius * 0.6 * (angle.sin());
      
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
