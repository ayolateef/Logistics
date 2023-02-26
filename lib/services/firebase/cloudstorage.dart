import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CloudStorageService {
  Future<CloudStorageResult?> uploadImage({
    @required File? imageToUpload,
    @required String? title,
  }) async {
    var imageFileName =
        title! + DateTime.now().millisecondsSinceEpoch.toString();

    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference firebaseStorageRef =
        firebaseStorage.ref().child('courrier/${imageFileName}');

    TaskSnapshot storageSnapshot =
        await firebaseStorageRef.putFile(imageToUpload!);
    if (storageSnapshot.state == TaskState.success) {
      var downloadUrl = await storageSnapshot.ref.getDownloadURL();

      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }

    return null;
  }

  Future deleteImage(String imageFileName) async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference firebaseStorageRef = firebaseStorage.ref().child(imageFileName);

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

class CloudStorageResult {
  final String? imageUrl;
  final String? imageFileName;

  CloudStorageResult({this.imageUrl, this.imageFileName});
}
