import 'package:flutter/material.dart';
import 'package:todos_sqlite/Database/db_todo.dart';
import 'package:todos_sqlite/Model/todo_model.dart';
import 'package:todos_sqlite/Screens/todo_screen.dart';

class TodoTile extends StatelessWidget {
  final TodoModel todo;
  const TodoTile({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(todo.title.substring(0, 2)),
      ),
      title: Text(todo.title),
      subtitle: Text(todo.description),
      trailing: GestureDetector(
        onTap: () {
          DatabaseTodo.deleteData(todo.id);
       
        },
        child: const Icon(
          Icons.clear_rounded,
          color: Colors.red,
        ),
      ),
    );
  }
}
