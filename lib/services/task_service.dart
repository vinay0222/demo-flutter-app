import 'package:uuid/uuid.dart';
import '../models/task.dart';

class TaskService {
  final _uuid = const Uuid();
  final List<Task> _tasks = [];

  List<Task> get allTasks => List.unmodifiable(_tasks);

  List<Task> get pendingTasks =>
      _tasks.where((t) => !t.isCompleted).toList();

  List<Task> get completedTasks =>
      _tasks.where((t) => t.isCompleted).toList();

  int get completionRate {
    if (_tasks.isEmpty) return 0;
    return (completedTasks.length / _tasks.length * 100).round();
  }

  /// Search tasks by title or description (case-insensitive).
  List<Task> search(String query) {
    if (query.trim().isEmpty) return allTasks;
    final q = query.toLowerCase();
    return _tasks
        .where((t) =>
            t.title.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q))
        .toList();
  }

  /// Returns tasks filtered by [priority].
  List<Task> byPriority(Priority priority) =>
      _tasks.where((t) => t.priority == priority).toList();

  Task addTask({
    required String title,
    String description = '',
    Priority priority = Priority.medium,
  }) {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      priority: priority,
      createdAt: DateTime.now(),
    );
    _tasks.add(task);
    return task;
  }

  bool toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return false;
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    return true;
  }

  bool deleteTask(String id) {
    final before = _tasks.length;
    _tasks.removeWhere((t) => t.id == id);
    return _tasks.length < before;
  }

  bool updateTask(String id, {String? title, String? description, Priority? priority}) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return false;
    _tasks[index] = _tasks[index].copyWith(
      title: title,
      description: description,
      priority: priority,
    );
    return true;
  }

  void clearCompleted() => _tasks.removeWhere((t) => t.isCompleted);
}
