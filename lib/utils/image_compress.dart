import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class AppImage {
  static Future<Uint8List> compressAndResizeImage(File file) async {
    img.Image? image = img.decodeImage(file.readAsBytesSync());
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    img.Image resizedImage = img.copyResize(
      image,
      width: 500,
    );
    return Uint8List.fromList(img.encodeJpg(resizedImage, quality: 95));
  }

  static Future<File?> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
