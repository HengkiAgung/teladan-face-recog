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
  List emb = detectFace(interpreter, img);

  final tempDir = await getApplicationDocumentsDirectory();
  String embPath = '${tempDir.path}/emb.json';
  File jsonFile = File(embPath);
  var data = {};

  if (jsonFile.existsSync()) {
    data = json.decode(jsonFile.readAsStringSync());
  }

  data[label] = emb;
  jsonFile.writeAsStringSync(json.encode(data));
  return true;
}

List detectFace(Interpreter interpreter, Image img) {
  List input = imageToByteListFloat32(img, 112, 128, 128);
  input = input.reshape([1, 112, 112, 3]);
  List output = List.filled(1 * 192, null, growable: false).reshape([1, 192]);
  interpreter.run(input, output);
  output = output.reshape([192]);
  List e1 = List.from(output);

  return e1;
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

Future<String> compare(List currEmb) async {
  //mengembalikan nama pemilik akun
  double minDist = 999;
  double currDist = 0.0;
  double threshold = 1.0;
  String predRes = "Tidak dikenali";
  print("currEmb: $currEmb");

  final tempDir = await getApplicationDocumentsDirectory();
  String embPath = '${tempDir.path}/emb.json';
  File jsonFile = File(embPath);
  var data = {};

  if (jsonFile.existsSync()) {
    data = json.decode(jsonFile.readAsStringSync());
  }

  for (String label in data.keys) {
    currDist = euclideanDistance(data[label], currEmb);
    if (currDist <= threshold && currDist < minDist) {
      minDist = currDist;
      predRes = label;
    }
  }
  return predRes;
}

double euclideanDistance(List e1, List e2) {
  double sum = 0.0;
  for (int i = 0; i < e1.length; i++) {
    sum += pow((e1[i] - e2[i]), 2);
  }
  return sqrt(sum);
}
