// screens/todo_screen.dart
import 'package:flutter/material.dart';

import '../api_service/api_service.dart';
import '../model/todo_model.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late Future<List<Todo>> todos;
  bool showCompleted = true;

  @override
  void initState() {
    super.initState();
    todos = ApiService.getTodos();
  }

  void _toggleCompleted() {
    setState(() {
      showCompleted = !showCompleted;
    });
  }

  Future<void> _showFilterOptions(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Show Completed'),
              onTap: () {
                Navigator.pop(context);
                _toggleCompleted();
              },
            ),
            ListTile(
              title: Text('Show Not Completed'),
              onTap: () {
                Navigator.pop(context);
                _toggleCompleted();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: todos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Todo> filteredTodos = snapshot.data!
                .where((todo) => showCompleted ? !todo.completed : todo.completed)
                .toList();

            return Column(
              children: [
                ListTile(
                  title: Text('Show Completed'),
                  trailing: Switch(
                    value: showCompleted,
                    onChanged: (value) {
                      _toggleCompleted();
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredTodos[index].title),
                        subtitle: Text(filteredTodos[index].completed
                            ? 'Completed'
                            : 'Not Completed'),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFilterOptions(context);
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }
}
