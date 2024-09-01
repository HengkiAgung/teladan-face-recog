import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

Future<tfl.Interpreter?> loadModel() async {
  // final gpuDelegateV2 = tfl.GpuDelegateV2(
  //     options: tfl.GpuDelegateOptionsV2(
  //         isPrecisionLossAllowed: false,
  //         // inferencePreference: tfl.TfLiteGpuInferenceUsage.fastSingleAnswer,
  //         // inferencePriority1: tfl.TfLiteGpuInferencePriority.minMemoryUsage,
  //         // inferencePriority2: tfl.TfLiteGpuInferencePriority.minLatency,
  //         // inferencePriority3: tfl.TfLiteGpuInferencePriority.auto,
  //         maxDelegatePartitions: 1));
  // var interpreterOptions = tfl.InterpreterOptions()..addDelegate(gpuDelegateV2);

  // return await tfl.Interpreter.fromAsset('assets/mobilefacenet.tflite',
  //     options: interpreterOptions);

  return await tfl.Interpreter.fromAsset('assets/mobilefacenet.tflite');
}
