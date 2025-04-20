// login_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = "";
  bool _isPasswordVisible = false;

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validasi sederhana (GANTI DENGAN LOGIKA AUTENTIKASI ASLI)
    if (email == 'user@example.com' && password == 'password') {
      // Arahkan ke halaman profil setelah login berhasil
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      setState(() {
        _errorMessage = "Email atau Password salah!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/login_illustration.svg', // Pastikan path ini benar
                    height: 200,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Welcome in Ingetin!",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Login to your account",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    // Menggunakan tema dari MaterialApp
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(12),
                    // ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    // Menggunakan tema dari MaterialApp
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(12),
                    // ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage,
                      style: TextStyle( // Bisa juga pakai GoogleFonts
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/forgot-password'); // Pastikan rute ini ada jika diaktifkan
                    },
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    // Style diambil dari tema MaterialApp
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.blueAccent,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    // ),
                    onPressed: _login,
                    child: Text(
                      "Login",
                      // Style font diambil dari tema ElevatedButton
                      // style: GoogleFonts.poppins(
                      //   fontSize: 18,
                      //   fontWeight: FontWeight.bold,
                      //   color: Colors.white,
                      // ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/register'); // Pastikan rute ini ada jika diaktifkan
                    },
                    child: Text(
                      "Don't have an account? Sign up",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
