import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class CameraService with ChangeNotifier {
  CameraController? _controller;
  CameraController get controller => _controller!;
  final ImagePicker _picker = ImagePicker();

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    await _controller!.initialize();
    notifyListeners();
  }

Future<String?> takePicture() async {
  if (!_controller!.value.isInitialized) {
    return null;
  }
  if (_controller!.value.isTakingPicture) {
    return null;
  }
  try {
    final XFile picture = await _controller!.takePicture();
    final imagePath = picture.path;
    return imagePath;
  } catch (e) {
    print(e);
    return null;
  }
}


  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
