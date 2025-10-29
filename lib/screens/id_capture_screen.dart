import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'customer_info_screen.dart';

class IdCaptureScreen extends StatefulWidget {
  const IdCaptureScreen({super.key});

  @override
  State<IdCaptureScreen> createState() => _IdCaptureScreenState();
}

class _IdCaptureScreenState extends State<IdCaptureScreen> {
  int _currentStep = 0;
  bool _frontCaptured = false;
  bool _backCaptured = false;
  File? _frontImage;
  File? _backImage;
  CameraController? _cameraController;
  bool _isCameraReady = false;
  bool _isCapturing = false;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Front Side',
      'subtitle': 'Capture the front side of your ID card',
      'icon': Icons.credit_card,
    },
    {
      'title': 'Back Side',
      'subtitle': 'Capture the back side of your ID card',
      'icon': Icons.credit_card,
    },
    {
      'title': 'Complete',
      'subtitle': 'ID verification completed',
      'icon': Icons.verified,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraReady = true;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile image = await _cameraController!.takePicture();

      setState(() {
        if (_currentStep == 0) {
          _frontImage = File(image.path);
          _frontCaptured = true;
        } else {
          _backImage = File(image.path);
          _backCaptured = true;
        }
        _currentStep++;
      });

      _showImagePreview(File(image.path));
    } catch (e) {
      print('Error capturing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error capturing image. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (_currentStep == 0) {
          _frontImage = File(image.path);
          _frontCaptured = true;
        } else {
          _backImage = File(image.path);
          _backCaptured = true;
        }
        _currentStep++;
      });

      _showImagePreview(File(image.path));
    }
  }

  void _showImagePreview(File imageFile) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              _currentStep == 1 ? 'Front Side Preview' : 'Back Side Preview',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio:
                      16 / 9, // or 4 / 3 depending on your camera ratio
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover, // makes it fill horizontally
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Is this image clear and readable?',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    if (_currentStep == 1) {
                      _frontImage = null;
                      _frontCaptured = false;
                    } else {
                      _backImage = null;
                      _backCaptured = false;
                    }
                    _currentStep--;
                  });
                },
                child: const Text('Retake'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (_currentStep == 2 && _backCaptured) {
                    _proceedToNextScreen();
                  }
                },
                child: const Text('Use This Photo'),
              ),
            ],
          ),
    );
  }

  void _proceedToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerInfoScreen()),
    );
  }

  void _showCaptureOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _captureImage();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraReady || _cameraController == null) {
      return Container(
        width: double.infinity,
        height: 200, // Reduced height
        color: Colors.black,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 8),
            Text(
              'Initializing Camera...',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      );
    }

    // Get camera aspect ratio for proper sizing
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final cameraRatio = _cameraController!.value.aspectRatio;

    return SizedBox(
      height: 200, // Fixed height for horizontal layout
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: size.width,
              height: size.width / cameraRatio,
              child: CameraPreview(_cameraController!),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCapturedImagePreview() {
    final File? currentImage = _currentStep == 0 ? _frontImage : _backImage;

    if (currentImage != null) {
      return Container(
        width: double.infinity,
        height: 200, // Same height as camera preview
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(currentImage, fit: BoxFit.cover),
        ),
      );
    }

    return _buildCameraPreview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'ID Verification',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress and Header - Fixed height section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Indicator
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / _steps.length,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),

                  // Current Step
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _steps[_currentStep]['icon'],
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _steps[_currentStep]['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              _steps[_currentStep]['subtitle'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Camera Preview - Fixed height
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCapturedImagePreview(),
            ),
            const SizedBox(height: 16),

            // Capture Status - Compact
            if (_currentStep < 2) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCaptureStatus('Front', _frontCaptured),
                    _buildCaptureStatus('Back', _backCaptured),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Instructions - Scrollable if needed
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Card(
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Capture Tips:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('• Ensure good lighting'),
                            Text('• Place ID on a dark surface'),
                            Text('• Avoid glare and shadows'),
                            Text('• Make sure all text is readable'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Action Buttons - Always visible at bottom
            Container(
              padding: const EdgeInsets.all(16),
              child:
                  _currentStep < 2
                      ? _buildCaptureButtons()
                      : _buildProceedButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _showCaptureOptions,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_library, size: 20),
                    SizedBox(width: 8),
                    Text('Gallery', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isCapturing ? null : _captureImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white, // 👈 Add this
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child:
                    _isCapturing
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 20),
                            SizedBox(width: 8),
                            Text('Capture', style: TextStyle(fontSize: 14)),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProceedButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _proceedToNextScreen,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'PROCEED TO ACCOUNT SETUP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureStatus(String label, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color:
                isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.camera_alt,
            color:
                isCompleted
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
