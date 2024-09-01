import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:teladan/face_detection/painter/face_detector_painter.dart';
import 'package:teladan/face_detection/utils/convertImage.dart';
import 'package:teladan/face_detection/utils/model.dart';
import 'package:teladan/face_detection/widget/camera_view.dart';
import 'package:teladan/face_detection/widget/detector_view.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class RegisterFacePage extends StatefulWidget {
  const RegisterFacePage({super.key});

  @override
  State<RegisterFacePage> createState() => _RegisterFacePageState();
}

class _RegisterFacePageState extends State<RegisterFacePage> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  String _faceData = 'Run 1';
  var _cameraLensDirection = CameraLensDirection.front;
  Interpreter? interpreter;

  Widget? detectorView;

  @override
  void initState() {
    super.initState();

    _start();
  }

  void _start() async {
    interpreter = await loadModel();
    if (interpreter == null) {
      print('Failed to load model.3');
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      detectorView = CameraView(
        title: 'Face Detector $_faceData',
        customPaint: _customPaint,
        onImage: _processImage,
        initialCameraLensDirection: _cameraLensDirection,
        onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
        isRegister: true,
      );
    });

    return detectorView!;
  }

  Future<void> _processImage(InputImage inputImage) async {
    print("didalam process image");
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
    print("face: $faces");
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      // convert InputImage to Image
      var image = decodeYUV420SP(inputImage);
      print("image: $image");

      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
        callBack,
        interpreter,
        image,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void callBack(String faceData) {
    print("faceData: $faceData");
    setState(() {
      _faceData = faceData;

      detectorView = DetectorView(
        title: 'Face Detector $_faceData',
        customPaint: _customPaint,
        text: _text,
        onImage: _processImage,
        initialCameraLensDirection: _cameraLensDirection,
        onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      );
    });

    print("_faceData: $_faceData");
  }
}
