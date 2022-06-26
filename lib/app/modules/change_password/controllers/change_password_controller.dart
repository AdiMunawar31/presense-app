import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController currentController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> changePassword() async {
    if (currentController.text.isNotEmpty &&
        newController.text.isNotEmpty &&
        confirmController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        if (newController.text == confirmController.text) {
          String currentEmail = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
              email: currentEmail, password: currentController.text);

          await auth.currentUser!.updatePassword(newController.text);

          Get.back();

          Get.snackbar(
            'Success',
            'Password Changed Successfully',
            backgroundColor: Colors.black38,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Password does not match!',
            'Make sure the New Password and Confirm Password must be the same',
            backgroundColor: Colors.black38,
            colorText: Colors.white,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
            'Password is too short',
            'Password must be at least 6 characters',
            backgroundColor: Colors.black38,
            colorText: Colors.white,
          );
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
            'Wrong Password',
            'Wrong password provided for that user.',
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
      } finally {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Input is required',
        'All inputs must be filled in',
        backgroundColor: Colors.black38,
        colorText: Colors.white,
      );
    }
  }
}
