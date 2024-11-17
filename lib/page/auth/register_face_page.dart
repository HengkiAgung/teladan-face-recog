// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teladan/bloc/user/user_bloc.dart';
import 'package:teladan/face_detection/painter/face_detector_painter.dart';
import 'package:teladan/face_detection/utils/convertImage.dart';
import 'package:teladan/face_detection/utils/model.dart';
import 'package:teladan/face_detection/utils/recog.dart';
import 'package:teladan/face_detection/widget/camera_view.dart';
import 'package:teladan/page/auth/reset_password_page.dart';
import 'package:teladan/page/main_page.dart';
import 'package:teladan/utils/auth.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

class RegisterFacePage extends StatefulWidget {
  List<dynamic> dataLogin;

  RegisterFacePage({super.key, required this.dataLogin});

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
  var _cameraLensDirection = CameraLensDirection.front;
  Interpreter? interpreter;
  List<Face> faces = [];

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
    return CameraView(
      type: "register",
      title: 'Face Detector',
      customPaint: _customPaint,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      isRegister: true,
      onRegister: saveFace,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    faces = await _faceDetector.processImage(inputImage);
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

      // recognizeFace(image, faces);

      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }

      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  // void recognizeFace(imglib.Image? image, List<Face> faces) {
  //   // i can get face on this loop
  //   // using model facenet
  //   if (interpreter != null && image != null) {
  //     for (final face in faces) {
  //       imglib.Image croppedImage = imglib.copyCrop(
  //         image,
  //         x: face.boundingBox.left.round(),
  //         y: face.boundingBox.top.round(),
  //         width: face.boundingBox.width.round(),
  //         height: face.boundingBox.height.round(),
  //       );

  //       croppedImage = imglib.copyResizeCropSquare(croppedImage, size: 112);
  //       recog(interpreter!, croppedImage);
  //     }
  //   }
  // }

  void saveFace(InputImage inputImage) async {
    final tempDir = await getApplicationDocumentsDirectory();
    String embPath = '${tempDir.path}/emb.json';
    File jsonFile = File(embPath);
    var data = {};

    if (jsonFile.existsSync()) {
      data = json.decode(jsonFile.readAsStringSync());
    }

    var image = decodeYUV420SP(inputImage);

    print("data: $data");

    print("banyak muka: ${faces.length}");

    print("input image: ${inputImage.toJson()['path']}");

    if (interpreter != null) {
      for (final face in faces) {
        imglib.Image croppedImage = imglib.copyCrop(
          image,
          x: face.boundingBox.left.round(),
          y: face.boundingBox.top.round(),
          width: face.boundingBox.width.round(),
          height: face.boundingBox.height.round(),
        );

        croppedImage = imglib.copyResizeCropSquare(croppedImage, size: 112);
        print("process saving face");

        saveEmb('user', interpreter!, croppedImage);
      }

      logingIn();
    }
  }

  void logingIn() async {
    await Auth().persistToken(widget.dataLogin[2]);

    context.read<UserBloc>().add(GetUser());

    if (widget.dataLogin[1] == 1 || widget.dataLogin[1] == "1") {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ResetPasswordPage(),
        ),
      );

      return;
    }
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => MainPage(index: 0),
      ),
    );
  }
}
