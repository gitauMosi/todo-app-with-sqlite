import 'package:get/get.dart';

import '../models/task.dart';
import '../services/db_services.dart';

class TaskController extends GetxController {
  final DatabaseServices _databaseServices = DatabaseServices.instance;
  RxList<Task> taskList = <Task>[].obs;
  bool isloaded = false;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
    isloaded = true;
  }
    

  Future<void> fetchTasks() async {
    try {
      List<Task> tasks = await _databaseServices.getTasks();
      taskList.assignAll(tasks); // Updates the observable list
    } catch (e) {
      print('Failed to fetch tasks: $e');
    }
  }

  Future<void> addTask(String task) async {
    try {
       _databaseServices.addtask(task);
      await fetchTasks(); // Refresh the task list after adding a task
    } catch (e) {
      print('Failed to add task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      _databaseServices.deleteTask(id);
      await fetchTasks(); // Refresh the task list after deleting a task
    } catch (e) {
      print('Failed to delete task: $e');
    }
  }

  Future<void> updateTaskStatus(int id, int status) async {
    try {
       _databaseServices.updateTaskStatus(id, status);
      await fetchTasks(); // Refresh the task list after updating a task
    } catch (e) {
      print('Failed to update task status: $e');
    }
  }
}
