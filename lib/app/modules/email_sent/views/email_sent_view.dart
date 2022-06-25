import 'package:d2ypresence/app/common/styles.dart';
import 'package:d2ypresence/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/email_sent_controller.dart';

class EmailSentView extends GetView<EmailSentController> {
  const EmailSentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMAIL SENT'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 120),
                Image.asset(
                  'assets/images/email.png',
                  width: 160,
                ),
                const SizedBox(height: 8.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Check Your Email",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "We have sent a password recover instructions to your email.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 60),
                InkWell(
                  onTap: () {
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 200,
                    height: 50,
                    decoration: BoxDecoration(
                        gradient:
                            const LinearGradient(colors: [blue100, blue200]),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green),
                    child: const Center(
                      child: Text('CONFIRM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
