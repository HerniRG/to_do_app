import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/model/item_model.dart';
import 'dart:convert';

class DataStorage {
  static void saveTodoItems(List<TodoItem> todoItems) async {
    final prefs = await SharedPreferences.getInstance();
    final todoItemsJson = todoItems.map((item) => item.toJson()).toList();
    await prefs.setString('todoItems', json.encode(todoItemsJson));
  }

  static Future<List<TodoItem>> loadTodoItems() async {
    final prefs = await SharedPreferences.getInstance();
    final todoItemsJson = prefs.getString('todoItems');
    if (todoItemsJson != null) {
      final List<dynamic> decoded = json.decode(todoItemsJson);
      final List<TodoItem> loadedItems =
          decoded.map((item) => TodoItem.fromJson(item)).toList();
      return loadedItems;
    }
    return [];
  }
}
