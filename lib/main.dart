import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/providers.dart';
import 'providers/dynamic_course_provider.dart';
import 'providers/dynamic_progress_provider.dart';
import 'providers/video_provider.dart';
import 'theme/app_theme.dart';
import 'utils/constants.dart';
import 'screens/auth_wrapper.dart';
import 'screens/admin/admin_panel_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize auth listener
  final authProvider = AuthProvider();
  authProvider.initializeAuthListener();
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(SpiritApp(authProvider: authProvider));
}

class SpiritApp extends StatelessWidget {
  final AuthProvider authProvider;

  const SpiritApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => DynamicCourseProvider()),
        ChangeNotifierProvider(create: (_) => DynamicProgressProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),

        // Keep old providers for backward compatibility
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme.copyWith(
          // Ensure Material Icons are loaded
          iconTheme: const IconThemeData(
            color: Colors.black87,
          ),
        ),
        home: const AuthWrapper(),
        routes: {
          '/admin': (context) => const AdminPanelScreen(),
        },
      ),
    );
  }
}
