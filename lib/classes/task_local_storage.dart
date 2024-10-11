import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/entities/task.dart';
import 'dart:convert'; // Este es necesario para jsonEncode y jsonDecode

class TaskLocalStorage {
  static const String _taskKey = 'task_list';
  

  // Guarda tareas en local storage
  Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskListJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_taskKey, taskListJson);
  }

  // Carga tareas desde local storage
  Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskListJson = prefs.getStringList(_taskKey);

    if (taskListJson != null) {
      return taskListJson.map((taskJson) => Task.fromJson(jsonDecode(taskJson))).toList();
    } else {
      return [];
    }
  }
}
