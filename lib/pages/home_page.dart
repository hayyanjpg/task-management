// home_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:uuid/uuid.dart'; // <- Pastikan dependency ada di pubspec.yaml

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  String _sortBy = 'Priority';
  bool _ascending = false;
  bool _showCompletedTasks = true;

  Future<bool> _showDeleteConfirmationDialog(Task task) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
                  const SizedBox(width: 10),
                  Text('Konfirmasi Hapus', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ],
              ),
              content: Text('Apakah Anda yakin ingin menghapus tugas "${task.title}"?', style: GoogleFonts.poppins()),
              actions: <Widget>[
                TextButton(
                  child: Text('Batal', style: GoogleFonts.poppins()),
                  onPressed: () => Navigator.of(context).pop(false), // Return false
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text('Hapus', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.of(context).pop(true), // Return true
                ),
              ],
            );
          },
        ) ?? false; // Default false jika dialog ditutup tanpa menekan tombol
  }

  void _deleteTask(Task task) {
    final deletedTaskTitle = task.title;
    context.read<TaskProvider>().deleteTask(task);

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tugas "$deletedTaskTitle" dihapus.'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(15),
      ),
    );
  }

  void _toggleTaskDone(Task task) {
     context.read<TaskProvider>().toggleTaskDone(task);
  }

  void _showTaskForm({Task? existingTask}) {
    String title = existingTask?.title ?? '';
    String description = existingTask?.description ?? '';
    String priority = existingTask?.priority ?? 'Low';
    DateTime? deadline = existingTask?.deadline;
    // Hapus variabel isDone yang tidak terpakai
    // bool isDone = existingTask?.isDone ?? false;

    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);
    DateTime? selectedDeadline = deadline;
    // Perbaiki penggunaan Uuid
    const uuid = Uuid(); // Gunakan const jika memungkinkan

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
             decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
             padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Padding untuk keyboard
                top: 20,
                left: 20,
                right: 20,
              ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    existingTask != null ? 'Edit Task' : 'Add New Task',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Tugas',
                      hintText: 'Masukkan judul tugas...',
                      prefixIcon: Icon(Icons.title_rounded),
                    ),
                    style: GoogleFonts.poppins(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      hintText: 'Masukkan deskripsi tugas...',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    style: GoogleFonts.poppins(),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  // Perbaiki parameter DropdownPriority
                  DropdownPriority(
                    value: priority, // Ganti selected menjadi value
                    onChanged: (val) => setModalState(() => priority = val!),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today_rounded),
                          // --- TAMBAHKAN KEMBALI Text ---
                          label: Text(
                            selectedDeadline == null
                                ? 'Pilih Deadline'
                                : DateFormat('dd MMM yyyy').format(selectedDeadline!),
                            style: GoogleFonts.poppins(),
                          ),
                          // --- AKHIR TAMBAHAN ---
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDeadline ?? DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 30)), // Bisa atur batas awal
                              lastDate: DateTime.now().add(const Duration(days: 365 * 2)), // Batas akhir 2 tahun
                            );
                            if (picked != null && picked != selectedDeadline) {
                              setModalState(() {
                                selectedDeadline = picked;
                              });
                            }
                          },
                        ),
                      ),
                      if (selectedDeadline != null)
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey.shade600),
                          tooltip: "Hapus Deadline",
                          onPressed: () => setModalState(() => selectedDeadline = null),
                        ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(existingTask != null ? Icons.update_rounded : Icons.add_task_rounded),
                      label: Text(existingTask != null ? 'Update Task' : 'Add Task'),
                      // Style diambil dari tema
                      onPressed: () {
                        final finalTitle = titleController.text.trim();
                        final finalDescription = descriptionController.text.trim();

                        // Validasi lebih baik: cek deadline juga
                        if (finalTitle.isEmpty) {
                           ScaffoldMessenger.of(context).removeCurrentSnackBar();
                           // --- TAMBAHKAN KEMBALI SnackBar ---
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(
                               content: Text('Judul tugas tidak boleh kosong!'),
                               backgroundColor: Colors.orangeAccent,
                               behavior: SnackBarBehavior.floating,
                             )
                           );
                           // --- AKHIR TAMBAHAN ---
                           return;
                        }
                        // Opsional: Validasi deadline jika diperlukan
                        // if (selectedDeadline == null) { ... }

                        if (existingTask != null) {
                          existingTask.title = finalTitle;
                          existingTask.description = finalDescription;
                          existingTask.priority = priority;
                          existingTask.deadline = selectedDeadline;
                          context.read<TaskProvider>().updateTask(existingTask);
                        } else {
                          final newTask = Task(
                            id: uuid.v4(),
                            title: finalTitle,
                            description: finalDescription,
                            priority: priority,
                            deadline: selectedDeadline,
                            isDone: false,
                          );
                          context.read<TaskProvider>().addTask(newTask);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _setSort(String sortBy, bool ascending) {
     setState(() {
       _sortBy = sortBy;
       _ascending = ascending;
     });
  }

  // --- IMPLEMENTASI HELPER VISUAL ---
  Widget _getPriorityIcon(String priority, {bool isDone = false}) {
    IconData iconData;
    Color color;
    switch (priority) {
      case 'High':
        iconData = Icons.priority_high_rounded;
        color = Colors.red.shade400;
        break;
      case 'Medium':
        iconData = Icons.remove_rounded;
        color = Colors.orange.shade500;
        break;
      case 'Low':
      default:
        iconData = Icons.low_priority_rounded;
        color = Colors.green.shade500;
        break;
    }
    return Icon(iconData, size: 18, color: isDone ? color.withAlpha(100) : color);
  }

  Color _getPriorityBackgroundColor(String priority, {bool isDone = false}) {
    Color color;
     switch (priority) {
      case 'High': color = Colors.red.shade100; break;
      case 'Medium': color = Colors.orange.shade100; break;
      case 'Low': default: color = Colors.green.shade100; break;
    }
    return isDone ? color.withAlpha(100) : color;
  }

  Color _getPriorityTextColor(String priority, {bool isDone = false}) {
     Color color;
     switch (priority) {
      case 'High': color = Colors.red.shade700; break;
      case 'Medium': color = Colors.orange.shade700; break;
      case 'Low': default: color = Colors.green.shade700; break;
    }
    return isDone ? color.withAlpha(150) : color;
  }

  Widget _buildPriorityChip(String priority, {bool isDone = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _getPriorityBackgroundColor(priority, isDone: isDone), // Gunakan helper color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        priority,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _getPriorityTextColor(priority, isDone: isDone), // Gunakan helper color
        ),
      ),
    );
  }

  bool _isDeadlineNear(DateTime? deadline, {bool isDone = false}) {
    if (isDone || deadline == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDay = DateTime(deadline.year, deadline.month, deadline.day);
    // Anggap dekat jika deadline hari ini atau besok
    return deadlineDay.isAtSameMomentAs(today) || deadlineDay.isAtSameMomentAs(today.add(const Duration(days: 1)));
  }
  // --- AKHIR IMPLEMENTASI HELPER VISUAL ---

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final allTasks = taskProvider.tasks;

    List<Task> filteredTasks;
    if (_showCompletedTasks) {
      filteredTasks = List.from(allTasks);
    } else {
      filteredTasks = allTasks.where((task) => !task.isDone).toList();
    }

    filteredTasks.sort((a, b) {
      if (a.isDone != b.isDone) {
        return a.isDone ? 1 : -1;
      }
      if (_sortBy == 'Priority') {
        const priorityOrder = {'Low': 0, 'Medium': 1, 'High': 2};
        final priorityA = priorityOrder[a.priority] ?? 0;
        final priorityB = priorityOrder[b.priority] ?? 0;
        return _ascending ? priorityA.compareTo(priorityB) : priorityB.compareTo(priorityA);
      } else if (_sortBy == 'Deadline') {
        final dateA = a.deadline;
        final dateB = b.deadline;
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return _ascending ? 1 : -1;
        if (dateB == null) return _ascending ? -1 : 1;
        return _ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
      }
      return 0;
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withAlpha((255 * 0.9).round()), // Ganti withOpacity
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        // --- TAMBAHKAN KEMBALI Text ---
        title: Text(
          'Daftar Tugas',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        // --- AKHIR TAMBAHAN ---
        actions: [
          Tooltip(
             message: _showCompletedTasks ? "Sembunyikan Selesai" : "Tampilkan Selesai",
             child: IconButton(
               icon: Icon(
                 _showCompletedTasks ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded,
                 color: Colors.black54,
               ),
               onPressed: () {
                 setState(() {
                   _showCompletedTasks = !_showCompletedTasks;
                 });
               },
             ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded, color: Colors.black54),
            tooltip: "Sort Tasks",
            onSelected: (value) {
              if (value == 'Priority' || value == 'Deadline') {
                 _setSort(value, (value == 'Deadline'));
              } else if (value == 'Ascending') {
                 _setSort(_sortBy, true);
              } else if (value == 'Descending') {
                 _setSort(_sortBy, false);
              }
            },
            itemBuilder: (context) => [
               // --- TAMBAHKAN KEMBALI child ---
               PopupMenuItem(value: 'Priority', child: Text('Sort by Priority', style: GoogleFonts.poppins())),
               PopupMenuItem(value: 'Deadline', child: Text('Sort by Deadline', style: GoogleFonts.poppins())),
               const PopupMenuDivider(),
               PopupMenuItem(value: 'Ascending', child: Text('Ascending', style: GoogleFonts.poppins())),
               PopupMenuItem(value: 'Descending', child: Text('Descending', style: GoogleFonts.poppins())),
               // --- AKHIR TAMBAHAN ---
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
           gradient: LinearGradient(
              colors: [Color(0xFFEDE7F6), Color(0xFFE1F5FE)], // Contoh gradient ungu-biru muda
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 90.0, top: 8.0),
            child: filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- TAMBAHKAN KEMBALI asset path ---
                        SvgPicture.asset(
                          'assets/empty_tasks.svg', // Ganti dengan path SVG Anda
                          height: 180,
                          semanticsLabel: 'Empty tasks illustration',
                        ),
                        // --- AKHIR TAMBAHAN ---
                        const SizedBox(height: 25),
                        Text(
                          allTasks.isEmpty ? "Belum ada tugas!" : "Tidak ada tugas untuk ditampilkan.",
                          style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                        ),
                         const SizedBox(height: 5),
                         Text(
                          allTasks.isEmpty
                            ? "Tekan '+' untuk menambah tugas baru."
                            : (_showCompletedTasks ? "Semua tugas sudah selesai!" : "Ubah filter untuk melihat tugas yang selesai."),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[600]),
                        ),
                      ],
                    )
                  )
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      final deadline = task.deadline;
                      final bool isDone = task.isDone;
                      final bool isNear = _isDeadlineNear(deadline, isDone: isDone);
                      final priority = task.priority;

                      return Dismissible(
                        key: ValueKey(task.id),
                        background: Container(
                          color: Colors.redAccent.withAlpha(150), // Ganti withOpacity
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await _showDeleteConfirmationDialog(task);
                        },
                        onDismissed: (direction) {
                          _deleteTask(task);
                        },
                        child: Card(
                          color: Colors.white.withAlpha(isDone ? 191 : 235), // Ganti withOpacity (0.75 : 0.92)
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: isDone ? 1 : 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isNear ? BorderSide(color: Colors.orange.shade300, width: 1.5) : BorderSide.none,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 70, // Sesuaikan tinggi dengan ListTile
                                decoration: BoxDecoration(
                                  color: _getPriorityBackgroundColor(priority, isDone: isDone).withAlpha(200), // Ganti withOpacity
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.only(left: 12, right: 5, top: 8, bottom: 8),
                                  leading: Checkbox(
                                    value: isDone,
                                    onChanged: (bool? value) {
                                      _toggleTaskDone(task);
                                    },
                                    activeColor: Theme.of(context).primaryColor,
                                    visualDensity: VisualDensity.compact,
                                    side: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          task.title,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: isDone ? Colors.black45 : Colors.black87,
                                            decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isNear)
                                        Padding(
                                          // --- TAMBAHKAN KEMBALI padding ---
                                          padding: const EdgeInsets.only(left: 8.0),
                                          // --- AKHIR TAMBAHAN ---
                                          child: Icon(Icons.warning_amber_rounded, color: Colors.orange.shade600, size: 18),
                                        ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        _buildPriorityChip(priority, isDone: isDone),
                                        const SizedBox(width: 8),
                                        if (deadline != null) ...[
                                          Icon(Icons.calendar_today_outlined, size: 12, color: isDone ? Colors.black38 : Colors.black54),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              DateFormat('dd MMM yyyy').format(deadline),
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                color: isDone ? Colors.black38 : Colors.black54,
                                                decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit_note_rounded, size: 22, color: isDone ? Colors.blueGrey.shade300 : Colors.blueGrey.shade600),
                                    tooltip: "Edit Task",
                                    visualDensity: VisualDensity.compact,
                                    onPressed: isDone ? null : () => _showTaskForm(existingTask: task),
                                  ),
                                  onTap: () {
                                     _showTaskDetails(task);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskForm(),
        tooltip: 'Add Task',
        icon: const Icon(Icons.add_task_rounded),
        label: Text("Add Task", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        // Style diambil dari tema
        elevation: 4,
      ),
    );
  }

  void _showTaskDetails(Task task) {
    final bool isDone = task.isDone;
    final priority = task.priority;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withAlpha(250), // Ganti withOpacity
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.task_alt_rounded, color: Theme.of(context).primaryColor),
            const SizedBox(width: 10),
            Expanded(child: Text(task.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                 children: [
                   Icon(isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, size: 18, color: isDone ? Colors.green : Colors.grey),
                   const SizedBox(width: 8),
                   Text('Status:', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                   const SizedBox(width: 5),
                   Text(isDone ? 'Selesai' : 'Belum Selesai', style: GoogleFonts.poppins()),
                 ],
               ),
              const SizedBox(height: 12),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Icon(Icons.description_outlined, size: 18, color: Colors.grey),
                   const SizedBox(width: 8),
                   Text('Deskripsi:', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                   const SizedBox(width: 5),
                   Expanded(child: Text(task.description.isEmpty ? '-' : task.description, style: GoogleFonts.poppins())),
                 ],
               ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _getPriorityIcon(priority, isDone: isDone),
                  const SizedBox(width: 8),
                  Text('Priority:', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 5),
                  _buildPriorityChip(priority, isDone: isDone),
                ],
              ),
              const SizedBox(height: 12),
              if (task.deadline != null)
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text('Deadline:', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 5),
                    Text(DateFormat('dd MMMM yyyy').format(task.deadline!), style: GoogleFonts.poppins()),
                  ],
                ),
            ],
          ),
        ),
        actions: <Widget>[
           TextButton.icon(
             icon: Icon(Icons.delete_forever_rounded, color: Colors.red.shade400),
             label: Text('Delete', style: GoogleFonts.poppins(color: Colors.red.shade400)),
             onPressed: () async {
               Navigator.of(context).pop();
               bool confirmed = await _showDeleteConfirmationDialog(task);
               if (confirmed) {
                 _deleteTask(task);
               }
             },
           ),
           const Spacer(),
           TextButton.icon(
             // --- TAMBAHKAN KEMBALI Icon & Text ---
             icon: Icon(
               isDone ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
               color: isDone ? Colors.orange.shade700 : Colors.green.shade600,
             ),
             label: Text(
               isDone ? 'Belum Selesai' : 'Tandai Selesai',
               style: GoogleFonts.poppins(color: isDone ? Colors.orange.shade700 : Colors.green.shade600),
             ),
             // --- AKHIR TAMBAHAN ---
             onPressed: () {
               Navigator.of(context).pop();
               _toggleTaskDone(task);
             },
           ),
          TextButton.icon(
            icon: const Icon(Icons.close_rounded),
            label: Text('Close', style: GoogleFonts.poppins()),
            onPressed: () { Navigator.of(context).pop(); },
            style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

// --- IMPLEMENTASI DropdownPriority ---
class DropdownPriority extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  // --- PERBAIKI CONSTRUCTOR DI SINI ---
  const DropdownPriority({
    super.key, // Gunakan super parameter untuk key
    required this.value,
    required this.onChanged,
  });
  // --- AKHIR PERBAIKAN ---

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Prioritas',
        prefixIcon: const Icon(Icons.flag_outlined),
        // Menggunakan tema dari MaterialApp
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: ['Low', 'Medium', 'High'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: GoogleFonts.poppins()),
        );
      }).toList(),
    );
  }
}
// --- AKHIR IMPLEMENTASI DropdownPriority ---
