import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_sqapp/controllers/task_controller.dart';
import 'package:todo_sqapp/widegts/custom_drawer.dart';

import '../models/task.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TaskController _controller = Get.put(TaskController());
  final TextEditingController _taskController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      drawer: const CustomDrawer(),
      body: Obx(() {
        if (_controller.taskList.isEmpty) {
          return  Center(
                  child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ));
              
        }
        return ListView.builder(
          itemCount: _controller.taskList.length,
          itemBuilder: (context, index) {
            Task task = _controller.taskList[index];
            return _buildTaskTile(task, _controller, context);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, _controller),
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTaskTile(
      Task task, TaskController controller, BuildContext context) {
    return ListTile(
      onLongPress: () {
        controller.deleteTask(task.id);
        Get.showSnackbar(
          GetSnackBar(
            title: "Task Deleted",
            message: "Task '${task.content}' deleted successfully",
            icon: const Icon(Icons.delete, color: Colors.red),
            backgroundColor: Colors.redAccent.withOpacity(0.7),
            snackPosition: SnackPosition.TOP,
            borderRadius: 16,
            margin: const EdgeInsets.all(8),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      leading: Radio<int>(
        activeColor: Theme.of(context).colorScheme.primary,
        value: 1,
        groupValue: task.status,
        onChanged: (value) => controller.updateTaskStatus(task.id, value!),
      ),
      title: Text(task.content),
      trailing: Checkbox(
        value: task.status == 1,
        onChanged: (value) =>
            controller.updateTaskStatus(task.id, value == true ? 1 : 0),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TaskController controller) {
    Get.dialog(
      AlertDialog(
        title: Text(
          "Add Task",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                  labelText: 'Task Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              onPressed: () {
                String taskContent = _taskController.text.trim();
                if (taskContent.isEmpty) {
                  Get.showSnackbar(
                    GetSnackBar(
                      title: "Error",
                      message: "Task content cannot be empty!",
                      icon: const Icon(Icons.error, color: Colors.red),
                      backgroundColor: Colors.redAccent.withOpacity(0.7),
                      snackPosition: SnackPosition.TOP,
                      borderRadius: 16,
                      margin: const EdgeInsets.all(8),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                controller.addTask(taskContent);
                _taskController.clear();
                Get.back(); // Close the dialog
                Get.showSnackbar(
                  GetSnackBar(
                    title: "Task Added",
                    message: 'Task added successfully',
                    icon: const Icon(Icons.verified, color: Colors.green),
                    backgroundColor: Colors.greenAccent.withOpacity(0.7),
                    snackPosition: SnackPosition.TOP,
                    borderRadius: 16,
                    margin: const EdgeInsets.all(8),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
