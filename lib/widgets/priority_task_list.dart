import 'package:flutter/material.dart';
import 'package:task_manager/entities/task.dart';
import 'package:task_manager/utility/capitalize_first_letter.dart';
import 'package:task_manager/utility/responsive.dart'; 

class PriorityTaskList extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onEdit;
  final Function(Task) onDelete;

  const PriorityTaskList({
    super.key,
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _PriorityTaskListState createState() => _PriorityTaskListState();
}

class _PriorityTaskListState extends State<PriorityTaskList> {
  String _selectedFilter = 'Todos'; // Estado para el filtro seleccionado

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context); 

    // Filtra las tareas según el filtro seleccionado
    List<Task> filteredTasks = _filterTasks(widget.tasks);

    return Column(
      children: [
        // Dropdown para seleccionar el filtro
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: _selectedFilter,
            items: [
              'Todos',
              'Alta',
              'Media',
              'Baja',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedFilter = value!; // Actualiza el filtro seleccionado
              });
            },
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              if (filteredTasks.isNotEmpty) _buildTaskSection(filteredTasks, responsive),
            ],
          ),
        ),
      ],
    );
  }

  // Filtra las tareas según la selección del filtro
  List<Task> _filterTasks(List<Task> tasks) {
    switch (_selectedFilter) {
      case 'Alta':
        return tasks.where((task) => task.priority.contains('priority 1')).toList();
      case 'Media':
        return tasks.where((task) => task.priority.contains('priority 2')).toList();
      case 'Baja':
        return tasks.where((task) =>
            task.priority.contains('priority 3') ||
            task.priority.contains('priority 4') ||
            task.priority.contains('priority 5') ||
            task.priority.contains('priority 6') ||
            task.priority.contains('priority 7') ||
            task.priority.contains('priority 8') ||
            task.priority.contains('priority 9')).toList();
      default: // Todos
        return tasks;
    }
  }

  Widget _buildTaskSection(List<Task> tasks, Responsive responsive) {
    // Agrupar tareas en bloques de tres
    final List<Task> highPriorityTasks =
        tasks.where((task) => task.priority.contains('priority 1')).toList();
    final List<Task> mediumPriorityTasks =
        tasks.where((task) => task.priority.contains('priority 2')).toList();
    final List<Task> lowPriorityTasks =
        tasks.where((task) =>
            task.priority.contains('priority 3') ||
            task.priority.contains('priority 4') ||
            task.priority.contains('priority 5') ||
            task.priority.contains('priority 6') ||
            task.priority.contains('priority 7') ||
            task.priority.contains('priority 8') ||
            task.priority.contains('priority 9')).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (highPriorityTasks.isNotEmpty)
          _buildTaskSectionThree(highPriorityTasks, 'Prioridad Alta',
              const Color.fromARGB(255, 144, 6, 6), responsive),
        if (mediumPriorityTasks.isNotEmpty)
          _buildTaskSectionThree(mediumPriorityTasks, 'Prioridad Media',
              const Color.fromARGB(255, 31, 181, 36), responsive),
        if (lowPriorityTasks.isNotEmpty)
          _buildTaskSectionThree(lowPriorityTasks, 'Prioridad Baja',
              const Color.fromARGB(255, 40, 142, 226), responsive),
      ],
    );
  }

  Widget _buildTaskSectionThree(List<Task> tasks, String title, Color color, Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        ...tasks.map((task) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Center(
              child: Container(
                
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: responsive.dp(42.5),
                  child: ListTile(
                    title: Text(
                      task.title.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      task.description.capitalizeFirstLetter(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.white,
                          onPressed: () {
                            widget.onEdit(task);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.white,
                          onPressed: () {
                            widget.onDelete(task);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
