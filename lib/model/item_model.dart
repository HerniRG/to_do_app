import 'package:uuid/uuid.dart';

class TodoItem {
  late String id;
  String title;
  bool isCompleted;

  TodoItem({String? id, required this.title, this.isCompleted = false}) {
    this.id = id ?? const Uuid().v4();
  }

  // Método para convertir un objeto TodoItem a un mapa
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Método para crear un objeto TodoItem a partir de un mapa
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }
}
