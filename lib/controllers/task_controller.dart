import 'package:get/get.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockTasks();
  }

  Task? getTaskById(String id) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  void _loadMockTasks() {
    tasks.assignAll([
      Task(
        id: '1',
        title: 'Design UI',
        description: 'Create UI mockups',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        latitude: 11.063670961387924,
        longitude: 76.98416132286478,
      ),
      Task(
        id: '2',
        title: 'Implement Features',
        description: 'Add new features',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        latitude: 11.352592520631218,
        longitude: 77.16551005477827,
      ),
      Task(
        id: '3',
        title: 'Testing',
        description: 'Test the application',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        latitude: 12.983712101061618,
        longitude: 77.60158725931302,
      ),
      Task(
        id: '4',
        title: 'Design UI',
        description: 'Create UI mockups',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        latitude: 15.393110900075529,
        longitude: 73.81270848634101,
      ),
      Task(
        id: '5',
        title: 'Design UI',
        description: 'Create UI mockups',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        latitude: 18.810423376283186,
        longitude: 80.78311043735832,
      ),
      Task(
        id: '6',
        title: 'Design UI',
        description: 'Create UI mockups',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        latitude: 22.589201429549586,
        longitude: 88.49257984434851,
      ),
    ]);
  }

  void toggleStatus(String id) {
    final task = tasks.firstWhere((task) => task.id == id);
    task.isCompleted = !task.isCompleted;
    tasks.refresh();
  }

  void addTask(Task task) {
    tasks.add(task);
  }

  void updateTask(Task updatedTask) {
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      tasks.refresh();
    }
  }

  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
  }
}
