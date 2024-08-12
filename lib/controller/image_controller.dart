import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../apis/apis.dart';

enum Status {
  none,
  loading,
  complete,
}

class ImageController extends GetxController {
  File? _image;
  final picker = ImagePicker();
  final status = Status.none.obs;
  final prediction = <double>[].obs;

  File? get image => _image;

  Future<void> takePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      update();
      await classifyImage();  // 사진 촬영 후 바로 분류
    } else {
      print('No image selected.');
    }
  }

  Future<void> classifyImage() async {
    if (_image != null) {
      status.value = Status.loading;
      try {
        prediction.value = await APIs.uploadImage(_image!);
        status.value = Status.complete;
      } catch (e) {
        status.value = Status.none;
        print("Error occurred: $e");
      }
    } else {
      print("No image to classify.");
    }
  }
}
