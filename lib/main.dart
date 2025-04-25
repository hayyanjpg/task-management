// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:task_manager/pages/login_page.dart';
import 'package:task_manager/pages/halamanprofil.dart';
import 'package:task_manager/pages/home_page.dart';
import 'package:task_manager/providers/task_provider.dart';
//import file register page dan forget password page
import 'package:task_manager/pages/register_page.dart';
import 'package:task_manager/pages/forgot_password_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData baseTheme = ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blueAccent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return MaterialApp(
      title: 'Ingetin Task Manager',
      theme: baseTheme.copyWith(
        colorScheme: (baseTheme.colorScheme.brightness == Brightness.light
                ? ColorScheme.light(primary: Colors.blueAccent)
                : ColorScheme.dark(primary: Colors.blueAccent))
            .copyWith(
              primaryContainer: Colors.blue.shade100,
              onPrimaryContainer: Colors.blue.shade900,
            ),
        textTheme: GoogleFonts.poppinsTextTheme(
          baseTheme.textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: baseTheme.colorScheme.primary,
            foregroundColor: baseTheme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: baseTheme.colorScheme.primary, width: 2),
          ),
          labelStyle: GoogleFonts.poppins(color: Colors.black54),
          floatingLabelStyle: GoogleFonts.poppins(color: baseTheme.colorScheme.primary),
          prefixIconColor: Colors.grey.shade600,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.only(bottom: 12),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/profile': (context) => const HalamanProfil(),
        '/home': (context) => const HalamanUtama(),
        '/register': (context) => const RegisterPage(), // Rute register
        '/forgot-password': (context) => const ForgotPasswordPage(), // Rute forgot password
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
