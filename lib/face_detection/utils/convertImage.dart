import 'dart:typed_data';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image/image.dart' as imglib;

imglib.Image decodeYUV420SP(InputImage image) {
  final width = image.metadata!.size.width.toInt();
  final height = image.metadata!.size.height.toInt();

  Uint8List yuv420sp = image.bytes!;
  var rotationOfCamera = 0;
  if (image.metadata != null && image.metadata!.rotation.rawValue != 0) {
    rotationOfCamera = image.metadata!.rotation.rawValue;
  }
  return decodeYUV420SP_from_camera(width, height, yuv420sp, rotationOfCamera);
}

imglib.Image decodeYUV420SP_from_camera(
    int width, int height, Uint8List yuv420sp, int rotationOfCamera) {
  var outImg =
      imglib.Image(width: width, height: height); // default numChannels is 3

  final int frameSize = width * height;

  for (int j = 0, yp = 0; j < height; j++) {
    int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
    for (int i = 0; i < width; i++, yp++) {
      int y = (0xff & yuv420sp[yp]) - 16;
      if (y < 0) y = 0;
      if ((i & 1) == 0) {
        v = (0xff & yuv420sp[uvp++]) - 128;
        u = (0xff & yuv420sp[uvp++]) - 128;
      }
      int y1192 = 1192 * y;
      int r = (y1192 + 1634 * v);
      int g = (y1192 - 833 * v - 400 * u);
      int b = (y1192 + 2066 * u);

      if (r < 0) {
        r = 0;
      } else if (r > 262143) {
        r = 262143;
      }
      if (g < 0) {
        g = 0;
      } else if (g > 262143) {
        g = 262143;
      }
      if (b < 0) {
        b = 0;
      } else if (b > 262143) {
        b = 262143;
      }
      outImg.setPixelRgb(i, j, ((r << 6) & 0xff0000) >> 16,
          ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff);
    }
  }

  if (rotationOfCamera != 0) {
    outImg = imglib.copyRotate(outImg, angle: rotationOfCamera);
  }
  return outImg;
}
