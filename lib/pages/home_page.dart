import 'package:flutter/material.dart';
import 'package:todo_sqapp/services/db_services.dart';

import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseServices _databaseServices = DatabaseServices.instance;
  String? task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _databaseServices.getTasks(),
         builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error.toString()}');
          }
          if (snapshot.data == null) {
            return Text('No tasks found');
          }
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              Task task = snapshot.data![index];
              return ListTile(
                onLongPress: (){
                  _databaseServices.deleteTask(task.id);
                  setState(() {});

                },
                title: Text(task.content),
                onTap: () {
                 
                },
                trailing: Checkbox(
                  value: task.status == 1,
                  onChanged: (value) {
                   _databaseServices.updateTaskStatus(
                    task.id, 
                    value == true ? 1 : 0
                    );
                    setState(() {});
                  },
                ),
              );
            },
          );
         }
         ),

      floatingActionButton: _addtaskButton(context),
    );
  }

  FloatingActionButton _addtaskButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text("Add Task"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            task = value;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Task Name',
                            border: OutlineInputBorder()),
                      ),
                      MaterialButton(
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          if (task == null || task == "") return;
                          _databaseServices.addtask(task!);
                          setState(() {
                            task = null;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ));
      },
      child: const Icon(Icons.add),
    );
  }
}
