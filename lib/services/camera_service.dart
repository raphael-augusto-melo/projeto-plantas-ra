import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraService with ChangeNotifier {
  CameraController? _controller;
  CameraController get controller => _controller!;
  final ImagePicker _picker = ImagePicker();

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(cameras[0], ResolutionPreset.high);
      await _controller!.initialize();
      notifyListeners();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<XFile?> takePicture() async {
    if (!_controller!.value.isInitialized || _controller!.value.isTakingPicture) {
      return null;
    }
    try {
      return await _controller!.takePicture();
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  Future<XFile?> pickImageFromGallery() async {
    try {
      return await _picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  Future<void> disposeController() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }
}
