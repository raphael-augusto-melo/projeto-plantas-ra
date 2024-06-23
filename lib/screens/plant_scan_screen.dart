import 'dart:io';
import 'package:camera/camera.dart';
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
  CameraService? _cameraService;
  late GeminiService _geminiService;
  File? _image;
  String? _result;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cameraService = Provider.of<CameraService>(context, listen: false);
    _geminiService = GeminiService();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _cameraService!.initializeCamera();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getImage(ImageSource source) async {
    XFile? pickedFile;
    if (source == ImageSource.camera) {
      pickedFile = await _cameraService!.takePicture();
      await _cameraService!.disposeController(); // Parar a pré-visualização da câmera
    } else {
      pickedFile = await _cameraService!.pickImageFromGallery();
    }

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile!.path);
        _isLoading = true;
      });

      try {
        final result = await _geminiService.analyzeImage(_image!);
        setState(() {
          _result = result;
          _isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResponseScreen(responseText: _result!),
          ),
        );
      } catch (e) {
        setState(() {
          _result = 'Error analyzing image: $e';
          _isLoading = false;
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
                ? (_cameraService == null || !_cameraService!.controller.value.isInitialized
                    ? const Center(child: CircularProgressIndicator())
                    : CameraPreview(_cameraService!.controller))
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(_image!),
                      if (_isLoading)
                        const Positioned(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
          ),
          if (_result != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_result!),
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Analisando imagem...'),
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

class ResponseScreen extends StatelessWidget {
  final String responseText;

  const ResponseScreen({required this.responseText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resposta do Gemini')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Text(
              responseText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
