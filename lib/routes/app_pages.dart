import 'package:get/get.dart';
import '../views/login_screen.dart';
import '../views/task_list_screen.dart';
import '../views/task_details_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.tasks,
      page: () => const TaskListScreen(),
    ),
    GetPage(
      name: '${AppRoutes.taskDetails}/:id',
      page: () {
        final taskId = Get.parameters['id'] ?? '';
        return TaskDetailsScreen(taskId: taskId);
      },
    ),
  ];
}
