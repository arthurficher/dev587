import 'package:flutter/material.dart';
import 'package:task_manager/classes/api_service.dart';
import 'package:task_manager/classes/task_edit_screen.dart';
import 'package:task_manager/entities/task.dart';
import 'package:task_manager/classes/task_local_storage.dart';
import 'package:task_manager/utility/responsive.dart';
import 'package:task_manager/widgets/priority_task_list.dart';

class TaskApp extends StatefulWidget {
  const TaskApp({super.key});
  @override
  _TaskAppState createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  late TaskLocalStorage _taskLocalStorage;
  late ApiService _apiService;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _taskLocalStorage = TaskLocalStorage();
    _apiService = ApiService();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      // carga las tareas localmente
      _tasks = await _taskLocalStorage.loadTasks();

      // Si no hay tareas locales, carga desde la API
      if (_tasks.isEmpty) {
        _tasks = await _apiService.fetchTasks();
        await _taskLocalStorage.saveTasks(
            _tasks); // Guarda las tareas obtenidas de la API localmente
      } // Guarda las tareas localmente
      _sortTasks();
      setState(() {});
    } catch (e) {
    }
    
  }

  void _addTask() async {
    // Navega a la pantalla de edición de tarea
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskEditScreen(
          onSave: (task) {
            setState(() {
              _tasks.add(task); // Agrega la nueva tarea a la lista
              _sortTasks();
            });
          },
        ),
      ),
    );

    if (newTask != null) {
      _tasks.add(newTask); // Agrega la nueva tarea si no es nula
      await _taskLocalStorage.saveTasks(_tasks); // Guarda la lista actualizada
    }
  }

  void _editTask(Task task) async {
    // Navega a la pantalla de edición de tarea con la tarea seleccionada
    final updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskEditScreen(
          task: task,
          onSave: (updatedTask) {
            setState(() {
              int index = _tasks.indexWhere((t) => t.id == task.id);
              if (index != -1) {
                _tasks[index] = updatedTask; // Actualiza la tarea en la lista
                _sortTasks();
              }
            });
          },
        ),
      ),
    );

    if (updatedTask != null) {
      // Si la tarea fue actualizada, guarda la lista
      await _taskLocalStorage.saveTasks(_tasks);
    }
  }

  void _deleteTask(Task task) async {
    // Muestra un diálogo de confirmación
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Cierra el diálogo y retorna false
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Cierra el diálogo y retorna true
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    // Si el usuario confirmó la eliminación
    if (confirmDelete == true) {
      setState(() {
        _tasks.remove(task);
        _sortTasks();
      });
      await _taskLocalStorage.saveTasks(_tasks);
    }
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      int priorityA = _extractPriority(a.priority);
      int priorityB = _extractPriority(b.priority);
      return priorityA.compareTo(priorityB);
    });
  }

// Función para extraer el número de prioridad de la cadena
  int _extractPriority(String priority) {
    final match = RegExp(r'\d+').firstMatch(priority);
    if (match != null) {
      return int.parse(match.group(0)!); // Devuelve el número encontrado
    }
    return 0; // Si no hay número, devuelve un valor por defecto (0)
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 34, 50),
        title: Center(
          child: Text(
            'Gestor de Tareas',
            style: TextStyle(
              fontSize: responsive.dp(2),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Botón de agregar tarea siempre visible
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                width: responsive.dp(20),
                height: responsive.dp(5),
                child: ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 1, 34, 50), // Color del botón
                  ),
                  child: Text(
                    'Agregar Tarea',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.dp(2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            // Lista de tareas
            child: _tasks.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : PriorityTaskList(
                    tasks: _tasks,
                    onEdit: _editTask,
                    onDelete: _deleteTask,
                  ),
          ),
        ],
      ),
    );
  }
}
