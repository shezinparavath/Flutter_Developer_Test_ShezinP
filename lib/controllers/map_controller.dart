import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);
  final Rx<LatLng> taskLocation = const LatLng(0, 0).obs;
  final RxBool isMapCreated = false.obs;
  final Rx<Marker?> marker = Rx<Marker?>(null);

  // Just add this one line for lazy loading
  final RxBool shouldLoadMap = false.obs;

  void updateLocation(LatLng location, {String? title}) {
    taskLocation.value = location;
    marker.value = Marker(
      markerId: const MarkerId('task_location'),
      position: location,
      infoWindow: InfoWindow(title: title ?? 'Task Location'),
    );

    if (isMapCreated.value) {
      mapController.value?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: location, zoom: 14.0),
        ),
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
    isMapCreated.value = true;

    if (taskLocation.value != const LatLng(0, 0)) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: taskLocation.value, zoom: 14.0),
        ),
      );
    }
  }

  @override
  void onClose() {
    mapController.value?.dispose();
    super.onClose();
  }
}
