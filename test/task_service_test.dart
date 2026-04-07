import 'package:flutter_test/flutter_test.dart';
import 'package:demo_flutter_app/services/task_service.dart';
import 'package:demo_flutter_app/models/task.dart';

void main() {
  group('TaskService', () {
    late TaskService service;

    setUp(() => service = TaskService());

    test('starts with no tasks', () {
      expect(service.allTasks, isEmpty);
    });

    test('addTask creates a task with correct fields', () {
      final task = service.addTask(title: 'Test task', priority: Priority.high);
      expect(service.allTasks.length, 1);
      expect(task.title, 'Test task');
      expect(task.priority, Priority.high);
      expect(task.isCompleted, isFalse);
    });

    test('toggleTask marks task completed and back', () {
      final task = service.addTask(title: 'Toggle me');
      expect(service.allTasks.first.isCompleted, isFalse);
      service.toggleTask(task.id);
      expect(service.allTasks.first.isCompleted, isTrue);
      service.toggleTask(task.id);
      expect(service.allTasks.first.isCompleted, isFalse);
    });

    test('completionRate returns correct percentage', () {
      service.addTask(title: 'A');
      service.addTask(title: 'B');
      final c = service.addTask(title: 'C');
      service.toggleTask(c.id);
      expect(service.completionRate, 33);
    });

    test('deleteTask removes the correct task', () {
      service.addTask(title: 'Keep');
      final toDelete = service.addTask(title: 'Delete me');
      service.deleteTask(toDelete.id);
      expect(service.allTasks.length, 1);
      expect(service.allTasks.first.title, 'Keep');
    });

    test('clearCompleted removes only done tasks', () {
      service.addTask(title: 'Pending');
      final done = service.addTask(title: 'Done');
      service.toggleTask(done.id);
      service.clearCompleted();
      expect(service.allTasks.length, 1);
      expect(service.allTasks.first.title, 'Pending');
    });

    test('toggleTask returns false for unknown id', () {
      expect(service.toggleTask('nonexistent'), isFalse);
    });
  });
}
