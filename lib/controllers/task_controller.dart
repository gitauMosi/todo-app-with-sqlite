import 'package:get/get.dart';
import '../models/task.dart';
import '../services/db_services.dart';

class TaskController extends GetxController {
  final DatabaseServices _databaseServices = DatabaseServices.instance;
  RxList<Task> taskList = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      List<Task> tasks = await _databaseServices.getTasks();
      taskList.assignAll(tasks); // Updates the observable list
    } catch (e) {
      print('Failed to fetch tasks: $e');
    }
  }

  Future<void> addTask(String taskContent) async {
    try {
      final newTaskId = await _databaseServices.addTask(taskContent);
      final newTask = Task(id: newTaskId, content: taskContent, status: 0);
      taskList.insert(0, newTask); // Add the new task to the beginning
    } catch (e) {
      print('Failed to add task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      _databaseServices.deleteTask(id);
      final index = taskList.indexWhere((task) => task.id == id);
      if (index != -1) {
        taskList.removeAt(index); // Remove the task locally
      }
    } catch (e) {
      print('Failed to delete task: $e');
    }
  }

  Future<void> updateTaskStatus(int id, int status) async {
    try {
      _databaseServices.updateTaskStatus(id, status);
      final index = taskList.indexWhere((task) => task.id == id);
      if (index != -1) {
        taskList[index] = Task(
          id: taskList[index].id,
          content: taskList[index].content,
          status: status,
        );
        taskList.refresh(); // Notify observers of the update
      }
    } catch (e) {
      print('Failed to update task status: $e');
    }
  }
}
