import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import 'onboarding_screen.dart';

class SimpleSplashScreen extends StatefulWidget {
  const SimpleSplashScreen({super.key});

  @override
  State<SimpleSplashScreen> createState() => _SimpleSplashScreenState();
}

class _SimpleSplashScreenState extends State<SimpleSplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B46C1),
              Color(0xFF7C3AED),
              Color(0xFF8B5CF6),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Simple logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFB8860B),
                      Color(0xFF6B46C1),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 40),
              
              // App name
              Text(
                'ALMIGHTY',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
              Text(
                'AUTHORITY',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              
              SizedBox(height: 20),
              
              Text(
                'Divine Wisdom • Spiritual Authority',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 60),
              
              // Loading indicator
              CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
              
              SizedBox(height: 16),
              
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
