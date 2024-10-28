// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:teladan/components/modal_bottom_sheet_component.dart';
import 'package:teladan/face_detection/painter/face_detector_painter.dart';
import 'package:teladan/face_detection/utils/convertImage.dart';
import 'package:teladan/face_detection/utils/model.dart';
import 'package:teladan/face_detection/utils/recog.dart';
import 'package:teladan/face_detection/widget/camera_view.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

class FaceDetectorView extends StatefulWidget {
  final String type;
  final Function(InputImage inputImage, String type) onClockInOut;

  FaceDetectorView({
    Key? key,
    required this.type,
    required this.onClockInOut,
  }) : super(key: key);

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
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

  bool _isRecognized = false;

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
    return CameraView(
      type: widget.type,
      title: 'Face Detector',
      customPaint: _customPaint,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      onClockInOut: onClockInOut,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      // convert InputImage to Image
      var image = decodeYUV420SP(inputImage);

      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );

      recognizeFace(image, faces);

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

  Future onClockInOut(BuildContext context, InputImage inputImage) async {
    print('proses: clock in');
    if (_isRecognized == false) {
      ModalBottomSheetComponent().errorIndicator(
        context,
        'Wajah tidak dikenali',
      );
      return;
    }

    widget.onClockInOut(inputImage, widget.type);
  }

  Future<bool> recognizeFace(imglib.Image? image, List<Face> faces) async {
    // i can get face on this loop
    // using model facenet
    if (interpreter != null && image != null) {
      for (final face in faces) {
        imglib.Image croppedImage = imglib.copyCrop(
          image,
          x: face.boundingBox.left.round(),
          y: face.boundingBox.top.round(),
          width: face.boundingBox.width.round(),
          height: face.boundingBox.height.round(),
        );

        croppedImage = imglib.copyResizeCropSquare(croppedImage, size: 112);
        String result = await recog(interpreter!, croppedImage);

        print('muka: $result');

        if (result == 'USER') {
          _isRecognized = true;
        }
      }
    }

    return false;
  }
}
