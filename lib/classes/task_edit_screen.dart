import 'package:flutter/material.dart';
import 'package:task_manager/entities/task.dart';


class TaskEditScreen extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskEditScreen({super.key, this.task, required this.onSave});

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _priority = widget.task?.priority == 'priority 1'
        ? 'alta'
        : widget.task?.priority == 'priority 2'
            ? 'media'
            : 'baja'; // Predeterminado a 'baja'
  }

  // Función para convertir la prioridad seleccionada en el formato adecuado
  String _convertPriorityToStorage(String priority) {
    switch (priority) {
      case 'alta':
        return 'priority 1';
      case 'media':
        return 'priority 2';
      case 'baja':
        return 'priority 3';
      default:
        return 'priority 3'; // Por defecto, 'baja'
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      // Convierte la prioridad seleccionada a su formato de almacenamiento
      String storedPriority = _convertPriorityToStorage(_priority);

      
      _formKey.currentState!.save();
      final task = Task(
        id: widget.task?.id ?? DateTime.now().toString(),
        title: _title,
        description: _description,
        priority: storedPriority,
      );
      widget.onSave(task); // Llama a la función onSave para guardar la tarea
      Navigator.pop(context); // Regresa a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nueva Tarea' : 'Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              
              /*TextFormField(
                initialValue: _priority,
                decoration: const InputDecoration(labelText: 'Prioridadd'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  return null;
                },
                onSaved: (value) => _priority = value!,
              ),*/

              DropdownButtonFormField<String>(
                value: _priority,
                items: const [
                  DropdownMenuItem(value: 'alta', child: Text('Alta')),
                  DropdownMenuItem(value: 'media', child: Text('Media')),
                  DropdownMenuItem(value: 'baja', child: Text('Baja')),
                ],
                decoration: const InputDecoration(labelText: 'Prioridad'),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                    print("Prioridad seleccionada: $_priority");
                  });
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text(widget.task == null ? 'Agregar Tarea' : 'Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
