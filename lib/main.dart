import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this import
import 'screens/get_started_screen.dart';
import 'providers/theme_provider.dart'; // Add this import
import 'theme.dart'; // We'll move theme data here
import 'screens/footer/app_screen.dart';
import 'screens/footer/scan_screen.dart';
import 'screens/footer/history_screen.dart';
import 'screens/footer/me_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { // Changed to StatelessWidget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // Provide theme state to enteire app
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Gamtaa App',
            theme: AppTheme.lightTheme, // Use from theme.dart
            darkTheme: AppTheme.darkTheme, // Use from theme.dart
            themeMode: themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            home: const GetStartedScreen(),
            routes: {
        '/home': (context) => const HomeScreen(),
        '/apps': (context) => const AppsScreen(),
        '/scan': (context) => const ScanScreen(),
        '/history': (context) => const HistoryScreen(),
        '/me': (context) => const MeScreen(),
      }, 
          );
        },
      ),
    );
  }
}
