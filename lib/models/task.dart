import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  final DateTime createdAt;
  final Priority priority;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.priority = Priority.medium,
  });

  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    Priority? priority,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
        'priority': priority.name,
      };
}

enum Priority { low, medium, high }

extension PriorityExtension on Priority {
  String get label {
    switch (this) {
      case Priority.low:    return 'Low';
      case Priority.medium: return 'Medium';
      case Priority.high:   return 'High';
    }
  }

  Color get color {
    switch (this) {
      case Priority.low:    return const Color(0xFF4CAF50);
      case Priority.medium: return const Color(0xFFFFC107);
      case Priority.high:   return const Color(0xFFF44336);
    }
  }
}
