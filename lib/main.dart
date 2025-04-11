import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:start_invest/modules/home/screen/home_screen.dart';
import 'package:start_invest/modules/login/provider/login_provider.dart'; // For loggedInUserEmailProvider
import 'package:start_invest/modules/login/provider/user_type_provider.dart'; // For userTypeProvider
import 'package:start_invest/modules/login/screen/login_screen.dart';
import 'package:start_invest/utils/database_helper.dart';
import 'package:start_invest/utils/shared_prefs_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize database first
  await DatabaseHelper().database;

  // Check login status using the helper
  final (loggedInEmail, userType) =
      await SharedPrefsHelper.instance.getLoginInfo();

  Widget initialScreen = const LoginScreen();
  // If both email and userType are stored, go to HomeScreen
  if (loggedInEmail != null && userType != null) {
    initialScreen = const HomeScreen();
  }

  runApp(
    ProviderScope(
      overrides: [
        // Initialize providers with stored values if they exist
        if (loggedInEmail != null)
          loggedInUserEmailProvider.overrideWith((ref) => loggedInEmail),
        if (userType != null) userTypeProvider.overrideWith((ref) => userType),
      ],
      child: MyApp(initialScreen: initialScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VentureNexus', // Added title
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: initialScreen, // Use the determined initial screen
    );
  }
}
