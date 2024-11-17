import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

Future<tfl.Interpreter?> loadModel() async {
  // return await tfl.Interpreter.fromAsset('assets/mobilefacenet.tflite');
  // return await tfl.Interpreter.fromAsset('assets/facenet.tflite');

  try {
    tfl.Interpreter interpreter = await tfl.Interpreter.fromAsset(
        // 'assets/facenet_1.tflite',
        // 'assets/FaceMobileNet_Float32.tflite',
        'assets/facenet.tflite',
        options: tfl.InterpreterOptions());

    return interpreter;
  } catch (e) {
    print('Unable to create interpreter, Caught Exception: ${e.toString()}');
  }
}
