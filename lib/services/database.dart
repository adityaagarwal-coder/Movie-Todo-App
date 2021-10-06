import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  updateTask(Map<String, dynamic> taskMap, String documentId) {
    FirebaseFirestore.instance
        // .collection("users")
        // .doc(userId)
        .collection("movies")
        .doc(documentId)
        .set(taskMap, SetOptions(merge: true));
  }

  createTask(Map<String, dynamic> taskMap) {
    FirebaseFirestore.instance
        // .collection("users")
        // .doc(userId)
        .collection("movies")
        .add(taskMap);
  }

  getTasks() async {
    return await FirebaseFirestore.instance
        // .collection("users")
        // .doc(userId)
        .collection("movies")
        .snapshots();
  }

  deleteTask(String documentId) {
    FirebaseFirestore.instance
        // .collection("users")
        // .doc(userId)
        .collection("movies")
        .doc(documentId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }
}
