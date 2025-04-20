// lib/pages/halaman_profil.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';
// Pastikan Anda mengimpor HomePage jika menggunakan MaterialPageRoute
// import 'package:task_manager/pages/home_page.dart';

class HalamanProfil extends StatefulWidget {
  const HalamanProfil({super.key});

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil> {
  // ... (Data user, _showNotifications, _logout tetap sama) ...
  final String userName = "Nama Pengguna Anda";
  final String? userProfileImageUrl = null;

  void _showNotifications() {
    // ... (kode notifikasi tidak berubah) ...
    final taskProvider = context.read<TaskProvider>();
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    final upcomingOrOverdueTasks = taskProvider.tasks.where((task) {
      if (task.deadline == null) return false;
      final deadlineDate = DateTime(task.deadline!.year, task.deadline!.month, task.deadline!.day);
      final todayDate = DateTime(now.year, now.month, now.day);
      final tomorrowDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
      return deadlineDate.isBefore(todayDate) || deadlineDate.isAtSameMomentAs(todayDate) || deadlineDate.isAtSameMomentAs(tomorrowDate);
    }).toList();

    String message;
    if (upcomingOrOverdueTasks.isEmpty) {
      message = "Tidak ada tugas yang mendekati deadline atau terlambat.";
    } else {
      message = "Ada ${upcomingOrOverdueTasks.length} tugas mendekati deadline atau terlambat:\n";
      message += upcomingOrOverdueTasks.map((t) => "- ${t.title}").join("\n");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _logout() {
    // ... (kode logout tidak berubah) ...
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login', // Pastikan route '/login' terdefinisi
      (Route<dynamic> route) => false,
    );
  }

  // --- Fungsi untuk Navigasi ke HomePage ---
  void _navigateToHomePage() {
    // Gunakan pushNamed jika Anda mendefinisikan route '/home'
    Navigator.pushNamed(context, '/home');
    // Atau gunakan push jika tidak menggunakan named routes
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const HomePage()), // Pastikan HomePage diimpor
    // );
    print("Navigasi ke HomePage"); // Pesan debug
  }
  // ------------------------------------

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final allTasks = taskProvider.tasks;
    final DateFormat dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // Tombol kembali otomatis SEHARUSNYA TIDAK ADA jika HalamanProfil
        // menggantikan halaman Login (karena tidak ada halaman sebelumnya di stack)
        // Jika tombol kembali muncul, cek logika navigasi di halaman Login Anda.
        // Kita bisa menyembunyikannya secara eksplisit jika perlu:
        automaticallyImplyLeading: false, // Sembunyikan tombol kembali default
        title: Text(
          'Profil Pengguna',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1.0,
        actions: [
          // --- Tombol Baru ke HomePage ---
          IconButton(
            icon: const Icon(Icons.list_alt_outlined), // Atau Icons.home_outlined
            tooltip: 'Lihat Tugas / Beranda', // Sesuaikan tooltip
            onPressed: _navigateToHomePage, // Panggil fungsi navigasi
          ),
          // -----------------------------

          // --- Tombol Aksi Logout ---
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text('Konfirmasi Logout'),
                    content: const Text('Apakah Anda yakin ingin keluar?'),
                    actions: [
                      TextButton(
                        child: const Text('Batal'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Logout', style: TextStyle(color: Colors.red.shade700)),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _logout();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // -------------------------
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Baru (Foto, Nama, Lonceng)
            _buildNewHeader(context),

            // Padding antar section
            const SizedBox(height: 20),

            // 2. Table Motivasi (#282b71)
            _buildMotivationBanner(context, allTasks.isEmpty),

            // Padding antar section
            const SizedBox(height: 25),

            // 3. Judul "Today's Tasks"
            _buildTodayTaskTitle(context),

            // 4. Table/List Tugas (#ffffff)
            Expanded(
              child: _buildTaskListContainer(context, allTasks, dateFormat, theme),
            ),
            const SizedBox(height: 16), // Padding bawah
          ],
        ),
      ),
    );
  }

  // ... (Semua widget _build... lainnya tetap sama) ...
  // Widget untuk Header Baru
  Widget _buildNewHeader(BuildContext context) {
    // Sesuaikan padding di sini jika perlu, karena sudah ada AppBar
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0, bottom: 10.0), // Kurangi padding atas
      child: Row(
        children: [
          // Foto Profil
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300, // Warna fallback
            backgroundImage: userProfileImageUrl != null
                ? NetworkImage(userProfileImageUrl!)
                : null,
            child: userProfileImageUrl == null
                ? Icon(
                    Icons.person_rounded,
                    size: 35,
                    color: Colors.grey.shade700,
                  )
                : null,
          ),
          const SizedBox(width: 12),

          // Teks Sapaan dan Nama
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello!',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  userName, // Ambil dari variabel
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle nama panjang
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Ikon Lonceng Notifikasi
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.grey.shade700,
              size: 28,
            ),
            onPressed: _showNotifications, // Panggil fungsi saat diklik
            tooltip: 'Lihat Notifikasi Tugas', // Tooltip saat hover/long press
          ),
        ],
      ),
    );
  }

  // Widget untuk Banner Motivasi
  Widget _buildMotivationBanner(BuildContext context, bool noTasks) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // Margin kiri kanan
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: const Color(0xFF282b71), // Warna sesuai permintaan
        borderRadius: BorderRadius.circular(12.0), // Sudut sedikit melengkung
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ]
      ),
      child: Row( // Menggunakan Row agar ikon dan teks sejajar
        children: [
           Icon(
            noTasks ? Icons.sentiment_very_satisfied_outlined : Icons.directions_run_rounded,
            color: Colors.white.withOpacity(0.9),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded( // Agar teks mengisi ruang
            child: Text(
              noTasks ? "Excellent!\nTidak ada tugas hari ini." : "Semangat!\nKerjakan tugasmu hari ini.",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.95),
                height: 1.3, // Jarak antar baris jika teks 2 baris
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Judul "Today's Tasks"
  Widget _buildTodayTaskTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
      child: Text(
        "Today's Tasks",
        style: GoogleFonts.poppins(
          fontSize: 22, // Font agak besar
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }

  // Widget Container untuk List Tugas
  Widget _buildTaskListContainer(BuildContext context, List<Task> tasks, DateFormat dateFormat, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Warna latar belakang putih untuk "table"
        borderRadius: BorderRadius.circular(12.0),
         boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: tasks.isEmpty
          ? _buildEmptyTaskList() // Tampilkan pesan jika kosong
          : _buildPopulatedTaskList(tasks, dateFormat, theme), // Tampilkan list jika ada
    );
  }

  // Widget untuk Pesan Saat List Tugas Kosong
  Widget _buildEmptyTaskList() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 15),
            Text(
              "Tidak ada tugas untuk ditampilkan.",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Menampilkan List Tugas yang Ada
  Widget _buildPopulatedTaskList(List<Task> tasks, DateFormat dateFormat, ThemeData theme) {
    // Gunakan ListView.builder untuk performa
    return ListView.builder(
      // Beri sedikit padding di dalam container putih
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        // Gunakan item task yang sudah ada atau buat yang baru/modifikasi
        // Mari kita gunakan versi modifikasi dari _buildTaskItem sebelumnya
        // agar cocok di dalam container putih
        return _buildTaskListItem(context, task, dateFormat, theme);
      },
    );
  }

  // Widget untuk Setiap Item Tugas dalam List (versi modifikasi)
  Widget _buildTaskListItem(BuildContext context, Task task, DateFormat dateFormat, ThemeData theme) {
    // Anda bisa menggunakan Card di sini atau langsung ListTile/Column
    // Mari gunakan ListTile untuk tampilan list yang rapi
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Sedikit jarak antar item
      child: ListTile(
        // Leading bisa berupa checkbox atau ikon status
        leading: Icon(
          task.isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          color: task.isDone ? Colors.green.shade400 : theme.primaryColor.withOpacity(0.8),
          size: 24,
        ),
        title: Text(
          task.title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: task.isDone ? Colors.grey.shade500 : Colors.black87,
            decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: task.deadline != null
            ? Text(
                'Deadline: ${dateFormat.format(task.deadline!)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: task.isDone ? Colors.grey.shade400 : Colors.grey.shade600,
                   decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              )
            : null,
        // Trailing bisa untuk prioritas atau tombol aksi
        trailing: _buildPriorityBadge(context, task.priority, task.isDone), // Gunakan badge prioritas
        // onTap: () {
        //   // Mungkin tambahkan aksi saat item di-tap? (misal edit/detail)
        //   print("Task item tapped: ${task.title}");
        // },
      ),
    );
  }

  // Widget untuk Badge Prioritas (mirip versi sebelumnya, disesuaikan)
  Widget _buildPriorityBadge(BuildContext context, String priority, bool isDone) {
    Color badgeColor;
    String priorityText;
    Color textColor;

    switch (priority) {
      case 'High':
        badgeColor = Colors.red.shade100;
        priorityText = 'Tinggi';
        textColor = Colors.red.shade800;
        break;
      case 'Medium':
        badgeColor = Colors.orange.shade100;
        priorityText = 'Sedang';
        textColor = Colors.orange.shade800;
        break;
      case 'Low':
      default:
        badgeColor = Colors.green.shade100;
        priorityText = 'Rendah';
        textColor = Colors.green.shade800;
        break;
    }

    // Buat badge lebih pudar jika tugas sudah selesai
    if (isDone) {
      badgeColor = Colors.grey.shade200;
      textColor = Colors.grey.shade500;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priorityText,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
