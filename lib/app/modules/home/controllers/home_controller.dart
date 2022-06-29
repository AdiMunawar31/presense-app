import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection('employee').doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastUser() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore
        .collection('employee')
        .doc(uid)
        .collection('presence')
        .orderBy('date')
        .limitToLast(5)
        .snapshots();
  }
}
