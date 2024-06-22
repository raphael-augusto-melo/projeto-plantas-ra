import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/camera_service.dart';
import '../services/gemini_service.dart';

class PlantScanScreen extends StatefulWidget {
  const PlantScanScreen({super.key});

  @override
  _PlantScanScreenState createState() => _PlantScanScreenState();
}

class _PlantScanScreenState extends State<PlantScanScreen> {
  late CameraService _cameraService;
  late GeminiService _geminiService;
  File? _image;
  String? _result;

  @override
  void initState() {
    super.initState();
    _cameraService = Provider.of<CameraService>(context, listen: false);
    _geminiService = GeminiService(dotenv.env['GEMINI_API_KEY']!);
    _cameraService.initializeCamera();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    XFile? pickedFile;
    if (source == ImageSource.camera) {
      pickedFile = (await _cameraService.takePicture()) as XFile?;
    } else {
      pickedFile = await _cameraService.pickImageFromGallery();
    }

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile!.path);
      });

      try {
        final result = await _geminiService.analyzeImage(_image!);
        setState(() {
          _result = result;
        });
      } catch (e) {
        setState(() {
          _result = 'Error analyzing image: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Plant')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _image == null
                ? const Center(child: Text('No image selected.'))
                : Image.file(_image!),
          ),
          if (_result != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_result!),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _getImage(ImageSource.camera),
            heroTag: 'camera',
            child: const Icon(Icons.camera),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _getImage(ImageSource.gallery),
            heroTag: 'gallery',
            child: const Icon(Icons.photo),
          ),
        ],
      ),
    );
  }
}
