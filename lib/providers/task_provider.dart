// lib/providers/task_provider.dart
import 'package:flutter/foundation.dart';
import 'package:task_manager/models/task.dart'; // Sesuaikan path jika perlu
import 'dart:collection'; // Untuk UnmodifiableListView

class TaskProvider with ChangeNotifier {
  // Gunakan List<Task>
  final List<Task> _tasks = [
    // Anda bisa menambahkan beberapa data awal di sini jika mau untuk testing
    // Task(id: 'initial-1', title: 'Contoh Tugas Awal 1', priority: 'Medium', deadline: DateTime.now().add(Duration(days: 1))),
    // Task(id: 'initial-2', title: 'Contoh Tugas Selesai', priority: 'Low', isDone: true, deadline: DateTime.now().subtract(Duration(days: 2))),
  ];

  // Getter untuk mendapatkan daftar tugas (tidak bisa dimodifikasi dari luar)
  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  // Method untuk menambah tugas baru
  void addTask(Task newTask) {
    _tasks.add(newTask);
    notifyListeners(); // Beri tahu listener bahwa data berubah
  }

  // Method untuk menghapus tugas
  void deleteTask(Task task) {
    _tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }

   // Method untuk menghapus tugas berdasarkan ID
  void deleteTaskById(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // Method untuk mengubah status selesai/belum selesai
  void toggleTaskDone(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index].isDone = !_tasks[index].isDone;
      notifyListeners();
    }
  }

   // Method untuk mengubah status selesai/belum selesai berdasarkan ID
  void toggleTaskDoneById(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isDone = !_tasks[index].isDone;
      notifyListeners();
    }
  }

  // Method untuk memperbarui tugas yang sudah ada
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  // Anda bisa menambahkan method lain jika perlu, misal getTaskById, dll.
}
