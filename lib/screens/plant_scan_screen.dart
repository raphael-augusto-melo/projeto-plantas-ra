import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
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
    _geminiService = GeminiService('AIzaSyDzFyVrF85lTHhxuSXAiABE4pukO4Vvp3Y'); // Substitute with your actual API key
    _cameraService.initializeCamera();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

Future<String?> analyzeImage(File image) async {
  // Use the Google Generative AI library to send the image to the Gemini endpoint
  // and process it according to your model definition.
  // Replace with your actual implementation using the library.
  final generativeModel = GenerativeModel(model: 'AIzaSyDzFyVrF85lTHhxuSXAiABE4pukO4Vvp3Y', apiKey: apiKey);
  final response = await generativeModel.runTextGeneration(image: image);
  if (response.statusCode == 200) {
    return response.data['generated_text'];
  } else {
    print('Error analyzing image: ${response.statusCode}');
    return null;
  }
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
        _image = File(pickedFile.path);
      });

      final result = await _geminiService.analyzeImage(_image!);
      setState(() {
        _result = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: _image == null
                ? Center(child: Text('No image selected.'))
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
          SizedBox(height: 16),
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
