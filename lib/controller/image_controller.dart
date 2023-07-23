import 'dart:io';

import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class ImageController extends GetxController {
  RxList<String> imageUrls = <String>[].obs;
  Rx<File?> selectedImage = Rx<File?>(null);

  void fetchImages() async {
    final querySnapshot = await firestore.collection('images').get();
    List<String> urls = querySnapshot.docs
        .map((doc) => doc.data()['imageUrl'] as String)
        .toList();
    imageUrls.value = urls;
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = storage.ref().child('images/$fileName');
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> insertImageUrl(String imageUrl, String text) async {
    await firestore.collection('new_collection').add({
      'imageUrl': imageUrl,
      'text': text,
    });
  }

  Future<void> uploadAndInsertImage(String text) async {
    File? imageFile = selectedImage.value;
    if (imageFile != null) {
      String imageUrl = await uploadImage(imageFile);
      await insertImageUrl(imageUrl, text);
      fetchImages();
    }
  }
}
