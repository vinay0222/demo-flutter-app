import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _taskService = TaskService();
  late TabController _tabController;

  int sumNumbers(int a, int b) {
    int i = a - b;
    return a;
  }
  
  @override
  void initState() {
    super.initState();
    int sum = sumNumbers(1, -2);
    _tabController = TabController(length: 2, vsync: this);
    // Seed a couple of demo tasks
    _taskService.addTask(title: 'Review PR #42', description: 'Check auth flow changes', priority: Priority.high);
    _taskService.addTask(title: 'Write unit tests', description: 'Cover edge cases in TaskService', priority: Priority.medium);
    _taskService.addTask(title: 'Update README', priority: Priority.low);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openAddTask() async {
    final task = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (task != null) {
      setState(() {
        _taskService.addTask(
          title: task.title,
          description: task.description,
          priority: task.priority,
        );
      });
    }
  }

  void _toggleTask(String id) => setState(() => _taskService.toggleTask(id));
  void _deleteTask(String id) => setState(() => _taskService.deleteTask(id));

  void _clearCompleted() {
    setState(() => _taskService.clearCompleted());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Completed tasks cleared.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending   = _taskService.pendingTasks;
    final completed = _taskService.completedTasks;
    final rate      = _taskService.completionRate;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text('My Tasks', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          if (completed.isNotEmpty)
            TextButton.icon(
              onPressed: _clearCompleted,
              icon: const Icon(Icons.cleaning_services_outlined, size: 18),
              label: const Text('Clear done'),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending (${pending.length})'),
            Tab(text: 'Done (${completed.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          if (_taskService.allTasks.isNotEmpty)
            _ProgressHeader(rate: rate, theme: theme),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TaskList(
                  tasks:      pending,
                  onToggle:   _toggleTask,
                  onDelete:   _deleteTask,
                  emptyLabel: 'No pending tasks 🎉',
                ),
                _TaskList(
                  tasks:      completed,
                  onToggle:   _toggleTask,
                  onDelete:   _deleteTask,
                  emptyLabel: 'Nothing completed yet.',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTask,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final int rate;
  final ThemeData theme;

  const _ProgressHeader({required this.rate, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: theme.textTheme.labelLarge),
              Text('$rate%',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: rate / 100,
              minHeight: 8,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(String) onToggle;
  final void Function(String) onDelete;
  final String emptyLabel;

  const _TaskList({
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(emptyLabel,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.grey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TaskTile(
          task:     tasks[i],
          onToggle: () => onToggle(tasks[i].id),
          onDelete: () => onDelete(tasks[i].id),
        ),
      ),
    );
  }
}
