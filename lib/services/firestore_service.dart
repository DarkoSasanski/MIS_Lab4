import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final CollectionReference examsCollection =
      FirebaseFirestore.instance.collection('exams');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getExams() async {
    User? user = _auth.currentUser;

    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await examsCollection
          .where('userId', isEqualTo: user.uid)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } else {
      return [];
    }
  }

  Future<void> addExam(String title, DateTime date) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await examsCollection.add({
          'title': title,
          'date': date,
          'userId': user.uid,
        });
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error adding exam: $e");
      }
      rethrow;
    }
  }
}
