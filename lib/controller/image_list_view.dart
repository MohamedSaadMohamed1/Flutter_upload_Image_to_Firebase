import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'image_controller.dart';

class ImageListView extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image List'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.imageUrls.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.network(controller.imageUrls[index]),
              title: Text('Image $index'),
              subtitle: Text('Accompanying Text'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickImageFromGallery(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      controller.selectedImage.value = imageFile;
      showSelectedImageDialog(context);
    }
  }

  void showSelectedImageDialog(BuildContext context) {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Selected Image'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(controller.selectedImage.value!),
              SizedBox(height: 16),
              Text('Enter Text:'),
              TextField(
                controller: textController,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String text = textController.text;
                controller.uploadAndInsertImage(text);
                Navigator.of(dialogContext).pop();
              },
              child: Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  void showTextInputDialog(BuildContext context) {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Enter Text'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String text = textController.text;
                controller.uploadAndInsertImage(text);
                Navigator.of(dialogContext).pop();
              },
              child: Text('Upload'),
            ),
          ],
        );
      },
    );
  }
}
