import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Uploads any files to Firebase Storage.
class FirebaseApi {
  /// Provide [destination] and [file] to upload to Firebase Storage.
  static UploadTask uploadFileApi(String destination, File file) {
    final ref = FirebaseStorage.instance.ref(destination);

    return ref.putFile(file);
  }
}


/// Upload images to Firebase Storage.
class UploadAttachment {
  static UploadTask? task;

  Future uploadPic({String? temuanId, required File file, required BuildContext context, String type = ''}) async {
    final fileName = basename(file.path);
    String destination = '';
    destination = 'images/$fileName';

    final ref = FirebaseStorage.instance.ref(destination);
    await ref.putFile(file);

    String downloadURL = await ref.getDownloadURL();

    return downloadURL;
  }

  /// Upload files.
  Future uploadFile({
    required File file,
  }) async {
    final fileName = basename(file.path);
    String destination = '';

    destination = 'files/$fileName';

    task = FirebaseApi.uploadFileApi(destination, file);

    if (task == null) return;

    // final snapshot = await task!.whenComplete(() {});
    // final downloadURL = await snapshot.ref.getDownloadURL();
    // return await Encryption.encryptText(context: context,text: downloadURL);
  }
}
