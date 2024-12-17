import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cloudinary_file_upload/services/cloudinary_service.dart';

class DbService {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> saveUploadedFileData(Map<String, String> data) async {
    await FirebaseFirestore.instance
        .collection('user-files')
        .doc(user!.uid)
        .collection('uploads')
        .doc()
        .set(data);
  }

  Stream<QuerySnapshot> readUploadedFiles() {
    return FirebaseFirestore.instance
        .collection('user-files')
        .doc(user!.uid)
        .collection('uploads')
        .snapshots();
  }

  Future<bool> deleteFile(String id, String public_id) async {
    final result = await deleteFromCloudinary(public_id);

    if (result) {
      await FirebaseFirestore.instance
          .collection('user-files')
          .doc(user!.uid)
          .collection('uploads')
          .doc(id)
          .delete();
      return true;
    } else {
      return false;
    }
  }
}
