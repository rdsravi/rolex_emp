import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  // Load images from the app's document directory
  Future<void> _loadImages() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = directory.listSync();

    // Filter to only include PNG files
    List<File> capturedImages = files
        .whereType<File>()
        .where((file) => file.path.endsWith('.png'))
        .toList();

    setState(() {
      _images = capturedImages;
    });
  }

  // Function to capture image using camera
  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      await File(image.path).copy(path); // Use await for copying
      _loadImages(); // Reload images to include the newly captured image
    }
  }

  // Function to pick an image from the gallery (not used for capturing images)
  Future<void> _pickImage() async {
    // Optionally, implement picking images from the gallery if required
  }

  // Build the gallery UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _captureImage,
          ),
        ],
      ),
      body: _images.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of images in each row
          childAspectRatio: 1.0, // Aspect ratio for the images
        ),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(imagePath: _images[index].path),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.file(
                _images[index],
                fit: BoxFit.cover,
              ),
            ),
          );
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
      appBar: AppBar(title: const Text('Display Picture')),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
