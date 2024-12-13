import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}
