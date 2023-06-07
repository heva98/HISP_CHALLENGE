import 'package:flutter/material.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final url = 'https://dev.hisptz.com/dhis2/api/dataStore/your-name?fields=.';
    final response = await http.get(Uri.parse(url),
        headers: {'Authorization': 'Basic YWRtaW46ZGlzdHJpY3Q='}); // Base64 encoded username:password (admin:district)

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final todosData = jsonData.values.toList();

      setState(() {
        todos = todosData.map((data) => Todo.fromJson(data)).toList();
      });
    } else {
      print('Failed to fetch todos: ${response.statusCode}');
    }
  }

  Future<void> addTodo() async {
    final url = 'https://dev.hisptz.com/dhis2/api/dataStore/your-name/todo-id';
    final newTodo = Todo(
      id: 'todo-id',
      title: 'New Todo',
      description: 'This is a new todo item',
      completed: false,
      created: DateTime.now().toIso8601String(),
      lastUpdated: DateTime.now().toIso8601String(),
    );
    final requestBody = jsonEncode(newTodo);

    final response = await http.post(Uri.parse(url),
        headers: {'Authorization': 'Basic YWRtaW46ZGlzdHJpY3Q='}, body: requestBody);

    if (response.statusCode == 200) {
      print('Todo added successfully');
      fetchTodos();
    } else {
      print('Failed to add todo: ${response.statusCode}');
    }
  }

  Future<void> updateTodoStatus(Todo todo, bool completed) async {
    final url = 'https://dev.hisptz.com/dhis2/api/dataStore/your-name/${todo.id}';
    final updatedTodo = Todo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: completed,
      created: todo.created,
      lastUpdated: DateTime.now().toIso8601String(),
    );
    final requestBody = jsonEncode(updatedTodo);

    final response = await http.put(Uri.parse(url),
        headers: {'Authorization': 'Basic YWRtaW46ZGlzdHJpY3Q='}, body: requestBody);

    if (response.statusCode == 200) {
      print('Todo status updated successfully');
      fetchTodos();
    } else {
      print('Failed to update todo status: ${response.statusCode}');
    }
  }

  Future<void> deleteTodoById(String id) async {
    final url = 'https://dev.hisptz.com/dhis2/api/dataStore/your-name/$id';

    final response = await http.delete(Uri.parse(url),
        headers: {'Authorization': 'Basic YWRtaW46ZGlzdHJpY3Q='});

    if (response.statusCode == 200) {
      print('Todo deleted successfully');
      fetchTodos();
    } else {
      print('Failed to delete todo: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-do List'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.description ?? ''),
            trailing: Checkbox(
              value: todo.completed,
              onChanged: (completed) => updateTodoStatus(todo, completed ?? false),
            ),
            onLongPress: () => deleteTodoById(todo.id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: Icon(Icons.add),
      ),
    );
  }
}
