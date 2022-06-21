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
        title: const Text('Add Employee'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
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
              colorButton(context, 'Create', () {
                controller.addEmployee();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
