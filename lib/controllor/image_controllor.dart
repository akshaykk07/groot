import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';

class PickImageController extends GetxController {
  final ImagePicker imagePicker = ImagePicker();
  RxList<XFile> imageFileList = RxList<XFile>();

  Future<void> selectImages() async {
    try {
      // ignore: unnecessary_nullable_for_final_variable_declarations
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages != null && selectedImages.isNotEmpty) {
        imageFileList.addAll(selectedImages);
        log('Selected images: $imageFileList');
      }
    } catch (e) {
      log('Error picking images: $e');
    }
  }

  Future<void> captureImage() async {
    try {
      final XFile? capturedImage =
          await imagePicker.pickImage(source: ImageSource.camera);
      if (capturedImage != null) {
        imageFileList.add(capturedImage);
        log('Captured image: $capturedImage');
      }
    } catch (e) {
      log('Error capturing image: $e');
    }
  }

  clearImage() {
    imageFileList.clear();
  }
}
