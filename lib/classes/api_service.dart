import 'dart:convert'; // Para convertir entre JSON y Map
import 'package:http/http.dart' as http;
import 'package:task_manager/entities/task.dart';

class ApiService {
  final String apiUrl = 'https://65f43f68f54db27bc02120e0.mockapi.io/api/v1/task';

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> taskListJson = jsonDecode(response.body);
      return taskListJson.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar tareas');
    }
  }
}
