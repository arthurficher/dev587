class Task {
  String title;
  String description;
  String priority;
  String id;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.id,
  });

  // Crear una instancia de Task desde JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      id: json['id'],
    );
  }

  // Convertir una instancia de Task a JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'id': id,
    };
  }
}
