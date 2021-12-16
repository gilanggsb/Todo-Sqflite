import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todos_sqlite/Database/db_todo.dart';
import 'package:todos_sqlite/Database/singleton_db.dart';
import 'package:todos_sqlite/Model/todo_model.dart';
import 'package:todos_sqlite/widget/todo_tile.dart';

class TodoScreen extends StatefulWidget {
  TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  // final List<TodoModel> todoList = [
  //   TodoModel(id: 1, title: 'HomeWork', description: 'MathPapers'),
  //   TodoModel(id: 2, title: 'Cooking', description: 'Noodles'),
  //   TodoModel(id: 3, title: 'Sleeping', description: 'Sleeping Till Morning'),
  //   TodoModel(id: 4, title: 'Watering', description: 'Watering Plants'),
  // ];
  List<TodoModel> todoList = <TodoModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // DatabaseTodo.getDatabaseConnect();
    SingletonDB.getDatabaseConnect();
   
  }

  @override
  Widget build(BuildContext context) {
    Future showFormDialog() {
      return showDialog(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.5),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Input Todo'),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        titleController.text = '';
                        descriptionController.text = '';
                      },
                      child: const Text('Clear')),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.lightBlue),
                      onPressed: () async {
                        final int count = await DatabaseTodo.getCount();
                        await SingletonDB.insertData(
                          TodoModel(
                              id: count + 1,
                              title: titleController.text,
                              description: descriptionController.text),
                        );
                        Navigator.pop(context);
                        setState(() {
                          SingletonDB.showAllData();
                        });
                        titleController.text = '';
                        descriptionController.text = '';
                        // print(
                        //     'ini title ${titleController.text} \n ini desc ${descriptionController.text}');
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(hintText: 'Title'),
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(hintText: 'Description'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar Sqlite'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showFormDialog();
        },
      ),
      body: FutureBuilder(
          future: SingletonDB.showAllData(),
          builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
            if (snapshot.hasData) {
              todoList = snapshot.data!;
              return ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    // return TodoTile(todo: todoList[index]);
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(todoList[index].title.substring(0, 2)),
                      ),
                      title: Text(todoList[index].title),
                      subtitle: Text(todoList[index].description),
                      trailing: GestureDetector(
                        onTap: () {
                          SingletonDB.deleteData(todoList[index].id);
                        setState(() {
                          
                        });
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          color: Colors.red,
                        ),
                      ),
                    );
                  });
            } else {
              return Container();
            }
          }),
    );
  }
}
