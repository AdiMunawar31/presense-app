import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d2ypresence/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection('employee').doc(uid).snapshots();
  }

  void logout(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to logout?'),
            actions: [
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Get.back();
                },
                isDefaultAction: false,
                isDestructiveAction: false,
                child: const Text('No'),
              ),

              // The "Yes" button
              CupertinoDialogAction(
                onPressed: () async {
                  await auth.signOut();
                  Get.offAllNamed(Routes.LOGIN);
                },
                isDefaultAction: true,
                isDestructiveAction: true,
                child: const Text('Yes'),
              ),
            ],
          );
        });
  }
}
