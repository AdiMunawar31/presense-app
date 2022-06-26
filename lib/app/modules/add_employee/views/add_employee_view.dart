import 'package:d2ypresence/app/widgets/color_button.dart';
import 'package:d2ypresence/app/widgets/input_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_employee_controller.dart';

class AddEmployeeView extends GetView<AddEmployeeController> {
  const AddEmployeeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD EMPLOYEE'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/add.png',
                  width: 250,
                ),
                const Text(
                  'Only admin can add new employees',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                inputItem(
                  context,
                  'NIP',
                  controller.nipController,
                  false,
                  const Icon(CupertinoIcons.grid_circle),
                ),
                const SizedBox(height: 20),
                inputItem(
                  context,
                  'Job',
                  controller.jobController,
                  false,
                  const Icon(CupertinoIcons.doc_circle),
                ),
                const SizedBox(height: 20),
                inputItem(
                  context,
                  'Name',
                  controller.nameController,
                  false,
                  const Icon(CupertinoIcons.person_circle),
                ),
                const SizedBox(height: 20),
                inputItem(
                  context,
                  'Email',
                  controller.emailController,
                  false,
                  const Icon(CupertinoIcons.at_circle),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => colorButton(context,
                      controller.isLoading.isFalse ? 'CREATE' : 'LOADING...',
                      () async {
                    if (controller.isLoading.isFalse) {
                      await controller.addEmployee(context);
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
