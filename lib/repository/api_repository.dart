import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicktasks/models/task.dart';

import '../providers/api_provider.dart';

final apiProvider = Provider<APIServiceRepositoryImpl>((ref) {
  return APIServiceRepositoryImpl();
});

abstract class APIRepository {
  Future<List<Task>> getTasks();
  Future<bool> saveTask(Task task);
  Future<bool> editTask(Task task);
  Future<bool> deleteTask(Task task);
}

class APIServiceRepositoryImpl implements APIRepository {
  @override
  Future<List<Task>> getTasks() async {
    try {
      var result = await APIProvider().get<dynamic>('/tasks/dolapobabs/.json');
      if (result != null) {
        List<Task> tasks = [];

        // Iterate over the map's values
        result.forEach((key, value) {
          if (value != null) {
            tasks.add(Task.fromJson(value));
          }
        });

        return tasks;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> deleteTask(Task task) async {
    try {
      var result = await APIProvider()
          .delete<dynamic>('/tasks/dolapobabs/${task.id}.json');
      if (result.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> editTask(Task task) async {
    try {
      var result = await APIProvider().patch<dynamic>(
          '/tasks/dolapobabs/${task.id}.json',
          data: task.toJson());
      if (result.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveTask(Task task) async {
    try {
      try {
        var result = await APIProvider().put<dynamic>(
            '/tasks/dolapobabs/${task.id}.json',
            data: task.toJson());
        if (result.statusCode == 200) {
          return true;
        }
        return false;
      } catch (e) {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
