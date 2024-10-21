import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rolex_emp/attendance/time_helper.dart';
import '../attendance/camera_helper.dart';
import '../calendar_page.dart';

class AttendanceController extends GetxController {
  RxString currentTime = ''.obs;
  RxString currentDate = ''.obs;
  RxString currentLocation = 'Fetching location...'.obs;
  CameraController? cameraController;
  RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  RxString? imagePath = ''.obs;
  RxBool isInTime = true.obs; // Track if it's IN TIME or OUT TIME
  RxList<Event> attendanceList = <Event>[].obs; // Attendance List to store attendance data
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _fetchCurrentLocation();
    _initializeCamera();
  }

  // Update the time every second
  void _updateTime() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      final DateTime now = DateTime.now();
      currentTime.value = formatTime(now); // Use the helper function
      currentDate.value = formatDate(now); // Use the helper function
    });
  }

  // Fetch current location using geolocator package
  Future<void> _fetchCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        currentLocation.value = "${placemark.name}, ${placemark.street}, ${placemark.locality}, "
            "${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.country}";
      } else {
        currentLocation.value = "Unable to fetch address";
      }
    } else {
      currentLocation.value = "Location permission denied";
    }
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    cameras.value = await availableCameras();
    cameraController = await initializeCamera(cameras);
    update();
  }

  // Capture the image
  Future<void> captureImage() async {
    if (cameraController == null) return;

    try {
      final image = await cameraController!.takePicture();
      final directory = await getTemporaryDirectory();
      final path = join(directory.path, 'attendance_${DateTime.now()}.png');
      await File(image.path).copy(path);
      imagePath?.value = path;

      // Save attendance data
      String attendanceTitle = isInTime.value ? 'In Time' : 'Out Time';
      attendanceList.add(Event(
        attendanceTitle,
        imagePath: path,
        time: currentTime.value,
        location: currentLocation.value,
        date: DateTime.now(),
      ));

      isInTime.value = !isInTime.value; // Toggle IN/OUT state
      print('Image saved at: $path');
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    timer?.cancel();
    super.onClose();
  }
}
