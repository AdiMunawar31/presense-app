import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d2ypresence/app/widgets/input_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmployeeController extends GetxController {
  final TextEditingController nipController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passAdminController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isLoadingValidate = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> processAddEmployee() async {
    if (passAdminController.text.isNotEmpty) {
      isLoadingValidate.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passAdminController.text);

        UserCredential credential = await auth.createUserWithEmailAndPassword(
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
            'role': 'user',
            'createdAt': DateTime.now().toIso8601String(),
          }).then((res) => {
                credential.user!.sendEmailVerification(),
                auth.signOut(),
                auth.signInWithEmailAndPassword(
                    email: emailAdmin, password: passAdminController.text),
                Get.back(),
                Get.back(),
                Get.snackbar(
                  'Success',
                  'Employee added successfully',
                  backgroundColor: Colors.black38,
                  colorText: Colors.white,
                ),
              });
        }
      } on FirebaseAuthException catch (e) {
        isLoadingValidate.value = false;
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
        isLoadingValidate.value = false;
        Get.snackbar(
          '500',
          'Internal Server Error',
          backgroundColor: Colors.black38,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Password Admin is Required',
        'Please enter the admin password for validation needs',
        backgroundColor: Colors.black38,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addEmployee(BuildContext context) async {
    if (nipController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      isLoading.value = true;
      /* Validation Admin */
      Get.defaultDialog(
          contentPadding: const EdgeInsets.only(bottom: 24.0, top: 12.0),
          titlePadding: const EdgeInsets.only(top: 24.0),
          title: 'Validation Admin',
          content: Column(
            children: [
              const Text("Please enter admin password :"),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: inputItem(context, 'Password', passAdminController, true,
                    const Icon(CupertinoIcons.lock_circle)),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  isLoading.value = false;
                  Get.back();
                },
                child: const Text('CANCEL')),
            Obx(
              () => ElevatedButton(
                  onPressed: () async {
                    if (isLoadingValidate.isFalse) {
                      await processAddEmployee();
                    }

                    isLoading.value = false;
                  },
                  child: Text(
                    isLoadingValidate.isFalse ? 'VALIDATE' : 'LOADING...',
                  )),
            ),
          ]);
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
