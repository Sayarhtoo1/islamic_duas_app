import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamic_duas_app/screens/dua_list_screen.dart';
import 'package:islamic_duas_app/screens/dua_detail_screen.dart';
import 'package:islamic_duas_app/screens/favorites_screen.dart';
import 'package:islamic_duas_app/providers/favorite_dua_provider.dart';
import 'package:islamic_duas_app/providers/settings_provider.dart'; // Import SettingsProvider
import 'package:islamic_duas_app/models/dua.dart';
import 'package:islamic_duas_app/theme/app_theme.dart';
import 'package:islamic_duas_app/screens/splash_screen.dart'; // Import the new splash screen
import 'package:islamic_duas_app/screens/settings_screen.dart'; // Import SettingsScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings(); // Load settings before running the app

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteDuaProvider()),
        ChangeNotifierProvider.value(value: settingsProvider), // Provide the pre-loaded instance
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'Islamic Duas App',
          theme: AppTheme.lightTheme(settingsProvider.textSize, settingsProvider),
          darkTheme: AppTheme.darkTheme(settingsProvider.textSize, settingsProvider),
          themeMode: settingsProvider.currentThemeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(), // Set splash screen as initial route
            '/home': (context) => DuaListScreen(), // New route for the main list screen
            '/duaDetail': (context) => DuaDetailScreen(
                  dua: ModalRoute.of(context)!.settings.arguments as Dua,
                ),
            '/favorites': (context) => FavoritesScreen(),
            '/settings': (context) => const SettingsScreen(), // Add settings route
          },
          debugShowCheckedModeBanner: false, // Remove debug banner
        );
      },
    );
  }
}
