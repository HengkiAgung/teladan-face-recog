import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<String> recog(Interpreter interpreter, Image img) async {
  List e1 = detectFace(interpreter, img);
  String face = await compare(e1);
  return face.toUpperCase();
}

Future<bool> saveEmb(String label, Interpreter interpreter, Image img) async {
  print("process masuk fungsi saveemb");
  List emb = detectFace(interpreter, img);

  print("process dapat emb: $emb");
  final tempDir = await getApplicationDocumentsDirectory();
  String embPath = '${tempDir.path}/emb.json';
  File jsonFile = File(embPath);
  var data = {};

  if (jsonFile.existsSync()) {
    data = json.decode(jsonFile.readAsStringSync());
  }

  data[label] = emb;
  jsonFile.writeAsStringSync(json.encode(data));

  print('data: $data');
  return true;
}

List detectFace(Interpreter interpreter, Image img) {
  // List input = imageToByteListFloat32(img, 112, 128, 128);
  // input = input.reshape([1, 112, 112, 3]);
  // List output = List.filled(1 * 192, null, growable: false).reshape([1, 192]);
  // interpreter.run(input, output);
  // // output = output.reshape([192]);

  // List e1 = output[0];

  // print("process detect face: $e1");

  var input = imageToArray(img);
  print(input.shape.toString());

  List output = List.filled(1 * 512, 0).reshape([1, 512]);

  final runs = DateTime.now().millisecondsSinceEpoch;
  interpreter.run(input, output);
  final run = DateTime.now().millisecondsSinceEpoch - runs;
  print('Time to run inference: $run ms$output');
  String stringOutput = output.first.toString();
  // print("process detect face: ${output.first}");

  return output.first;
}

Float32List imageToByteListFloat32(
    Image image, int inputSize, double mean, double std) {
  var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  var buffer = Float32List.view(convertedBytes.buffer);
  int pixelIndex = 0;
  for (var i = 0; i < inputSize; i++) {
    for (var j = 0; j < inputSize; j++) {
      PixelFloat32.image(image).forEach((element) {
        buffer[pixelIndex++] = (element - mean) / std;
      });
    }
  }
  return convertedBytes.buffer.asFloat32List();
}

Future<String> compare(List newEmb) async {
  //mengembalikan nama pemilik akun
  double minDist = double.maxFinite; // Mengatur jarak minimum awal
  double threshold = 10.0; // Threshold untuk menentukan wajah dikenali
  String predRes = "Tidak dikenali";

  final tempDir = await getApplicationDocumentsDirectory();
  String embPath = '${tempDir.path}/emb.json';
  File jsonFile = File(embPath);
  Map<String, dynamic> data = {};

  if (jsonFile.existsSync()) {
    data = json.decode(await jsonFile.readAsString());
  } else {
    print("File emb.json tidak ditemukan");
    return predRes;
  }

  for (String label in data.keys) {
    // Pastikan data[label] di-cast ke List<double>
    List<double> storedEmb = List<double>.from(data[label]);
    List<double> currEmb = List<double>.from(newEmb);

    print("currEmb: $currEmb");
    print("storedEmb: $storedEmb");

    double currDist = euclideanDistance(storedEmb, currEmb);

    print("Label: $label, Jarak: $currDist");

    if (currDist <= threshold && currDist < minDist) {
      minDist = currDist;
      predRes = label;
    }

    print("process compare: $currDist" +
        " , threshold: " +
        threshold.toString() +
        " , Label: " +
        predRes);
  }

  return predRes;
}

// Fungsi untuk menghitung jarak Euclidean
double euclideanDistance(List<double> emb1, List<double> emb2) {
  if (emb1.length != emb2.length) {
    throw Exception(
        "Embedding length mismatch: ${emb1.length} vs ${emb2.length}");
  }

  double sum = 0.0;
  for (int i = 0; i < emb1.length; i++) {
    sum += (emb1[i] * 10 - emb2[i] * 10) * (emb1[i] * 10 - emb2[i] * 10);
  }

  print("sum: $sum");

  return sqrt(sum);
}

List<dynamic> imageToArray(Image inputImage) {
  Image resizedImage = copyResize(inputImage, width: 160, height: 160);
  List<double> flattenedList = resizedImage.data!
      .expand((channel) => [channel.r, channel.g, channel.b])
      .map((value) => value.toDouble())
      .toList();
  Float32List float32Array = Float32List.fromList(flattenedList);
  int channels = 3;
  int height = 160;
  int width = 160;
  Float32List reshapedArray = Float32List(1 * height * width * channels);
  for (int c = 0; c < channels; c++) {
    for (int h = 0; h < height; h++) {
      for (int w = 0; w < width; w++) {
        int index = c * height * width + h * width + w;
        reshapedArray[index] =
            (float32Array[c * height * width + h * width + w] - 127.5) / 127.5;
      }
    }
  }
  return reshapedArray.reshape([1, 160, 160, 3]);
}
