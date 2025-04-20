// lib/models/task.dart
// Hapus import foundation.dart jika @required tidak digunakan
// import 'package:flutter/foundation.dart';

class Task {
  final String id; // ID unik untuk setiap task
  String title;
  String description;
  String priority;
  DateTime? deadline;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = 'Low', // Default priority
    this.deadline,
    this.isDone = false,
  });

  // Opsional: Factory constructor untuk membuat dari Map (jika diperlukan)
  factory Task.fromMap(Map<String, dynamic> map) {
    DateTime? parsedDeadline;
    if (map['deadline'] != null) {
      // Coba parse dari ISO string atau Timestamp (jika dari Firestore)
      if (map['deadline'] is String) {
        parsedDeadline = DateTime.tryParse(map['deadline']);
      } else if (map['deadline'] is num) { // Handle Timestamp (epoch milliseconds)
         parsedDeadline = DateTime.fromMillisecondsSinceEpoch(map['deadline']);
      }
      // Tambahkan penanganan lain jika format berbeda
    }

    return Task(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(), // Pastikan ada ID
      title: map['title'] ?? 'No Title',
      description: map['description'] ?? '',
      priority: map['priority'] ?? 'Low',
      deadline: parsedDeadline, // Gunakan hasil parse
      isDone: map['isDone'] ?? false,
    );
  }

  // Opsional: Method untuk mengubah ke Map (jika diperlukan)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      // Simpan sebagai millisecondsSinceEpoch untuk kompatibilitas lebih luas (misal Firestore)
      'deadline': deadline?.millisecondsSinceEpoch,
      'isDone': isDone,
    };
  }
}
