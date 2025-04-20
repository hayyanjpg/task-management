// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

// Import halaman-halaman Anda
import 'package:task_manager/pages/login_page.dart';
// --- PERBAIKI IMPORT DI SINI ---
import 'package:task_manager/pages/halamanprofil.dart'; // Pastikan nama file benar
// --- AKHIR PERBAIKAN ---
import 'package:task_manager/pages/home_page.dart';
import 'package:task_manager/providers/task_provider.dart';
// Import register page jika rutenya diaktifkan nanti
// import 'package:task_manager/pages/register_page.dart';

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
      primarySwatch: Colors.blue, // Atau gunakan ColorScheme.fromSeed
      primaryColor: Colors.blueAccent, // primaryColor deprecated, gunakan colorScheme.primary
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // Pertimbangkan menggunakan ColorScheme.fromSeed untuk tema modern
      // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    );

    return MaterialApp(
      title: 'Ingetin Task Manager',
      theme: baseTheme.copyWith(
        // Gunakan colorScheme untuk warna utama
        colorScheme: (baseTheme.colorScheme.brightness == Brightness.light
                ? ColorScheme.light(primary: Colors.blueAccent) // Definisikan primary untuk light
                : ColorScheme.dark(primary: Colors.blueAccent) // Definisikan primary untuk dark (jika perlu)
            )
            .copyWith(
              // --- HAPUS ?? DAN FALLBACK ---
              // primaryContainer: baseTheme.primaryColorLight, // Gunakan langsung
              // onPrimaryContainer: baseTheme.primaryColorDark, // Gunakan langsung
              // Atau definisikan secara eksplisit jika perlu
              primaryContainer: Colors.blue.shade100,
              onPrimaryContainer: Colors.blue.shade900,
              // --- AKHIR PERUBAHAN ---
            ),
        // Terapkan textTheme
        textTheme: GoogleFonts.poppinsTextTheme(
          baseTheme.textTheme,
        ),
        // Tema komponen lainnya
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: baseTheme.colorScheme.primary, // Gunakan dari colorScheme
            foregroundColor: baseTheme.colorScheme.onPrimary, // Warna teks di atas primary
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
            borderSide: BorderSide(color: baseTheme.colorScheme.primary, width: 2), // Gunakan dari colorScheme
          ),
          labelStyle: GoogleFonts.poppins(color: Colors.black54),
          floatingLabelStyle: GoogleFonts.poppins(color: baseTheme.colorScheme.primary), // Gunakan dari colorScheme
          prefixIconColor: Colors.grey.shade600,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.only(bottom: 12),
        ),
        // Pastikan primaryColorLight dan primaryColorDark tersedia atau definisikan di colorScheme
        // primaryColorLight: Colors.blue.shade100, // Contoh definisi eksplisit
        // primaryColorDark: Colors.blue.shade900, // Contoh definisi eksplisit
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        // --- Penggunaan HalamanProfil sekarang benar ---
        '/profile': (context) => const HalamanProfil(),
        // --- AKHIR PERUBAHAN ---
        '/home': (context) => const HalamanUtama(),
        // '/register': (context) => const RegisterPage(), // Aktifkan jika perlu
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
