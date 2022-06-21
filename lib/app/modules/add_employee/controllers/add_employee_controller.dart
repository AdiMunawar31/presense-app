import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmployeeController extends GetxController {
  final TextEditingController nipController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addEmployee() async {
    if (nipController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      try {
        final credential = await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: 'password',
        );

        if (credential.user != null) {
          String uid = credential.user!.uid;

          await firestore.collection('employee').doc(uid).set({
            'nip': nipController.text,
            'name': nameController.text,
            'email': emailController.text,
            'uid': uid,
            'createdAt': DateTime.now().toIso8601String(),
          }).then((value) => {
                Get.snackbar(
                  'Success',
                  'Employee added successfully',
                  backgroundColor: Colors.black38,
                  colorText: Colors.white,
                ),
                nipController.clear(),
                nameController.clear(),
                emailController.clear(),
                credential.user!.sendEmailVerification(),
              });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
            'Weak Password',
            'The password provided is too weak.',
            backgroundColor: Colors.black38,
            colorText: Colors.white,
          );
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar(
            'Email Already in Use',
            'The account already exists for that email.',
            backgroundColor: Colors.black38,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            e.code,
            e.message!,
            backgroundColor: Colors.black38,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          '500',
          'Internal Server Error',
          backgroundColor: Colors.black38,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'There is an error',
        'All inputs must be filled in',
        backgroundColor: Colors.black38,
        colorText: Colors.white,
      );
    }
  }
}
