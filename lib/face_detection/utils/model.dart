import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

Future<tfl.Interpreter?> loadModel() async {
  return await tfl.Interpreter.fromAsset('assets/mobilefacenet.tflite');
}
