import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task_tracker/controllers/task_controller.dart';

import '../controllers/map_controller.dart';
import '../models/task_model.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key, required this.taskId});
  final String taskId;

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Simple lazy loading - just show placeholder first
  Widget _buildMapSection(Task task, MapController mapController) {
    return Obx(() {
      // Show placeholder until user taps
      if (!mapController.shouldLoadMap.value) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => mapController.shouldLoadMap.value = true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 48, color: Colors.grey.shade500),
                const SizedBox(height: 8),
                Text(
                  'Tap to load map',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      }

      // Show actual map
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(task.latitude, task.longitude),
          zoom: 14.0,
        ),
        markers: mapController.marker.value != null
            ? {mapController.marker.value!}
            : {},
        onMapCreated: (controller) {
          mapController.onMapCreated(controller);
          // Update location after map is created
          mapController.updateLocation(
            LatLng(task.latitude, task.longitude),
            title: task.title,
          );
        },
        // Simple optimizations
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: false,
        mapToolbarEnabled: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MapController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: GetX<TaskController>(
        builder: (taskController) {
          final task = taskController.getTaskById(taskId);

          if (task == null) {
            return const Center(child: Text('Task not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Chip
                Align(
                  alignment: Alignment.centerRight,
                  child: Chip(
                    label: Text(
                      task.isCompleted ? 'Completed' : 'Pending',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: task.isCompleted
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 16),

                // Due Date
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Due: ${_formatDate(task.dueDate)}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Location
                const Text(
                  'Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Map - only if location exists
                if (task.latitude != 0 && task.longitude != 0)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildMapSection(task, mapController),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'No location data',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Action Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => taskController.toggleStatus(task.id),
                    icon: Icon(
                      task.isCompleted ? Icons.refresh : Icons.check_circle,
                      color: Colors.white,
                    ),
                    label: Text(
                      task.isCompleted ? 'Mark as Pending' : 'Mark as Complete',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: task.isCompleted
                          ? Colors.orange
                          : Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
