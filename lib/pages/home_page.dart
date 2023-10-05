import 'package:flutter/material.dart';
import 'package:to_do_app/data/data_storage.dart';
import 'package:to_do_app/model/item_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<TodoItem> todoItems = [];

  @override
  void initState() {
    super.initState();
    // Carga los datos al iniciar la pantalla
    _loadTodoItems();
  }

  // Método para guardar la lista de todoItems en SharedPreferences
  void _saveTodoItems() {
    DataStorage.saveTodoItems(todoItems);
  }

  // Método para cargar la lista de todoItems desde SharedPreferences
  void _loadTodoItems() async {
    final loadedItems = await DataStorage.loadTodoItems();
    setState(() {
      todoItems = loadedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.format_list_bulleted_add),
            SizedBox(width: 10),
            Text('Lista de Tareas'),
          ],
        ),
      ),
      body: ReorderableListView(
        onReorder: _reorderItems,
        children: _buildTodoItems(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Función para reordenar los elementos de la lista
  void _reorderItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = todoItems[oldIndex];
      todoItems.removeAt(oldIndex);
      todoItems.insertAll(newIndex, [item]);
      _saveTodoItems();
    });
  }

  // Construye la lista de elementos de la lista de tareas
  List<Widget> _buildTodoItems() {
    List<Widget> items = [];
    for (var item in todoItems) {
      items.add(buildTodoItem(item));
    }
    return items;
  }

  // Construye un elemento de la lista de tareas
  Widget buildTodoItem(TodoItem item) {
    return Dismissible(
      key: Key(item.id),
      onDismissed: (direction) {
        setState(() {
          todoItems.remove(item);
          _saveTodoItems();
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tarea eliminada'),
        ));
      },
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        leading: Checkbox(
          value: item.isCompleted,
          onChanged: (value) {
            setState(() {
              item.isCompleted = value!;
              _saveTodoItems();
            });
          },
        ),
        trailing: IconButton(
          onPressed: () {
            _editItemDescription(context, item);
          },
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }

  // Muestra el diálogo para agregar un nuevo elemento a la lista de tareas
  void _showAddItemDialog(BuildContext context) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildAddItemDialog(textController);
      },
    );
  }

  // Construye el diálogo para agregar un nuevo elemento
  Widget _buildAddItemDialog(TextEditingController textController) {
    return AlertDialog(
      title: const Text('Agregar Tarea'),
      content: TextField(
        controller: textController,
      ),
      actions: <Widget>[
        OutlinedButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        OutlinedButton(
          child: const Text('Agregar'),
          onPressed: () {
            setState(() {
              final newItem = TodoItem(title: textController.text);
              todoItems.add(newItem);
              _saveTodoItems();
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  // Muestra el diálogo para editar la descripción de un elemento de la lista
  void _editItemDescription(BuildContext context, TodoItem item) {
    final textController = TextEditingController(text: item.title);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildEditItemDialog(textController, item);
      },
    );
  }

  // Construye el diálogo para editar la descripción de un elemento
  Widget _buildEditItemDialog(
      TextEditingController textController, TodoItem item) {
    return AlertDialog(
      title: const Text('Editar Tarea'),
      content: TextField(
        controller: textController,
      ),
      actions: <Widget>[
        OutlinedButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        OutlinedButton(
          child: const Text('Guardar'),
          onPressed: () {
            setState(() {
              item.title = textController.text;
              _saveTodoItems();
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
