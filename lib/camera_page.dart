import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'gallery_page.dart';
import 'package:cross_file/cross_file.dart';
import 'package:share_plus/share_plus.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> cameras;
  CameraDescription? selectedCamera;
  List<String> _imagePaths = [];
  GlobalKey _imageKey = GlobalKey();
  Position? _currentPosition;
  String _locationMessage = "Fetching location...";
  String? _lastCapturedImagePath;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadSavedImages();
    _getCurrentLocation();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    selectedCamera = cameras.first;

    _controller = CameraController(
      selectedCamera!,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  Future<void> _loadSavedImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePaths = prefs.getStringList('imagePaths') ?? [];
    });
  }

  Future<void> _saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _imagePaths.add(imagePath);
    await prefs.setStringList('imagePaths', _imagePaths);
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Location services are disabled.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Location permissions are permanently denied.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      setState(() {
        _locationMessage = "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Error getting address: $e";
      });
    }
  }

  Future<void> _saveImageWithOverlay() async {
    try {
      // Capture image with overlay
      RenderRepaintBoundary boundary = _imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      Uint8List? byteData = (await image.toByteData(format: ImageByteFormat.png))?.buffer.asUint8List();
      if (byteData != null) {
        // Save image locally
        final directory = await getApplicationDocumentsDirectory();
        String newPath = path.join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.png');
        File(newPath).writeAsBytesSync(byteData);

        await _saveImagePath(newPath); // Save the image path to SharedPreferences
        setState(() {
          _lastCapturedImagePath = newPath;
        });

        // Navigate to the display screen with the captured image
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(imagePath: newPath),
          ),
        );

        print("Image saved successfully to device!");
      }
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                RepaintBoundary(
                  key: _imageKey,
                  child: Stack(
                    children: [
                      CameraPreview(_controller),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Text(
                          DateTime.now().toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 40,
                        child: Text(
                          _locationMessage,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo, size: 40, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => GalleryPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 40),
                      FloatingActionButton(
                        onPressed: () async {
                          await _saveImageWithOverlay();
                        },
                        child: const Icon(Icons.camera_alt),
                      ),
                      SizedBox(width: 40),
                      IconButton(
                        icon: Icon(Icons.share, size: 40, color: Colors.white),
                        onPressed: () {
                          if (_lastCapturedImagePath != null) {
                            Share.shareXFiles([XFile(_lastCapturedImagePath!)]);
                          } else {
                            print("No image to share");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captured Image')),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
