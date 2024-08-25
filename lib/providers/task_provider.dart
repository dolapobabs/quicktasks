// providers/task_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicktasks/repository/api_repository.dart';
import '../models/task.dart';
import '../services/task_database.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(
      ref.watch(tasksDatabaseServiceProvider), ref.read(apiProvider));
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final TaskDatabaseService _taskDatabaseService;
  final APIRepository _apiRepository;
  TaskNotifier(this._taskDatabaseService, this._apiRepository) : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    //state = await _taskDatabaseService.getTasks();
    try {
      state = await _apiRepository.getTasks();
    } catch (e) {
      state = await _taskDatabaseService.getTasks();
    }
  }

  Future<void> syncTasks() async {
    try {
      state = await _apiRepository.getTasks();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addTask(Task task) async {
    try {
      var result = await _taskDatabaseService.insertTaskAsync(task);
      state = [...state, result];
      await _apiRepository.saveTask(result);
    } catch (e) {}
  }

  void editTask(Task task) async {
    try {
      await _taskDatabaseService.updateTask(task);
      state = [
        for (final t in state)
          if (t.id == task.id) task else t,
      ];
      await _apiRepository.editTask(task);
    } catch (e) {}
  }

  // void updateTask(Task updatedTask) {
  //   state = [
  //     for (final task in state)
  //       if (task.id == updatedTask.id) updatedTask else task,
  //   ];
  // }

  void deleteTask(Task task) async {
    try {
      await _taskDatabaseService.deleteTask(task);
      state = state.where((t) => t != task).toList();
      await _apiRepository.deleteTask(task);
    } catch (e) {}
  }

  void toggleComplete(Task task) async {
    try {
      task.isComplete = !task.isComplete;
      await _taskDatabaseService.updateTask(task);
      state = [
        for (final t in state)
          if (t.id == task.id) task else t,
      ];
      await _apiRepository.editTask(task);
    } catch (e) {}
  }
}
