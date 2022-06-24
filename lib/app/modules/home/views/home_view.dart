import 'package:d2ypresence/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.ADD_EMPLOYEE);
              },
              icon: const Icon(CupertinoIcons.person_crop_circle_badge_plus)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              FirebaseAuth.instance.currentUser!.email!,
              style: const TextStyle(fontSize: 20),
            ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAllNamed(Routes.LOGIN);
                },
                child: const Text('LOGOUT'))
          ],
        ),
      ),
    );
  }
}
