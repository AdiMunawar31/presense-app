import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d2ypresence/app/common/styles.dart';
import 'package:d2ypresence/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/all_presence_controller.dart';

class AllPresenceView extends GetView<AllPresenceController> {
  const AllPresenceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ALL PRESENCE'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GetBuilder<AllPresenceController>(builder: (c) {
            return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: controller.getPresence(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: size.height,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return SizedBox(
                        height: size.height,
                        child: const Center(
                          child: Text('No history presence yet',
                              style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.bold)),
                        ));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = snapshot.data!.docs[index].data();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7090B0).withOpacity(0.2),
                              blurRadius: 20.0,
                              offset: const Offset(0, 10.0),
                            )
                          ],
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.DETAIL_PRESENCE, arguments: data),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Enter the office',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat.yMMMEd().format(
                                          DateTime.parse(data['date']),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    data['in']?['date'] == null
                                        ? '-'
                                        : DateFormat.jms().format(
                                            DateTime.parse(data['in']!['date']),
                                          ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  const Text(
                                    'Out of office',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    data['out']?['date'] == null
                                        ? '-'
                                        : DateFormat.jms().format(
                                            DateTime.parse(data['out']!['date']),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                });
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              height: size.height / 2,
              child: SfDateRangePicker(
                // onSelectionChanged: (){},
                selectionMode: DateRangePickerSelectionMode.range,
                showActionButtons: true,
                onCancel: () => Get.back(),
                onSubmit: (value) {
                  if (value != null) {
                    if ((value as PickerDateRange).endDate != null) {
                      controller.pickDate(value.startDate!, value.endDate!);
                    }
                  }
                },
              ),
            ),
          ));
        },
        child: const Icon(Icons.format_list_bulleted_rounded),
      ),
    );
  }
}
