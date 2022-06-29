import 'package:d2ypresence/app/common/styles.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presence_controller.dart';

class DetailPresenceView extends GetView<DetailPresenceController> {
  final Map<String, dynamic> data = Get.arguments;

  DetailPresenceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text('DETAIL PRESENCE'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //! Card 1

                  Container(
                    width: size.width,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7090B0).withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10.0),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        DateFormat.yMMMMEEEEd().format(
                          DateTime.parse(data['date']),
                        ),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //TODO Enter The Office =============================================================================

                  const SizedBox(height: 16.0),

                  Divider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),

                  const SizedBox(height: 16.0),
                  //! CARD 2

                  Container(
                    width: size.width,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7090B0).withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10.0),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Enter the office',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: blue400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  //! CARD 3

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7090B0).withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10.0),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hour',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          data['in']?['date'] == null
                              ? '-'
                              : DateFormat.jms().format(
                                  DateTime.parse(data['in']!['date']),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  //! CARD 4

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7090B0).withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10.0),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Position',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(data['in']?['lat'] == null ? '-' : "${data['in']?['lat']}, ${data['in']?['long']}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  //! CARD 5

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7090B0).withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10.0),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Distance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(data['in']?['distance'] == null ? '-' : '${data['in']?['distance']} m'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  //! CARD 6

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7090B0).withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10.0),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(data['in']?['status'] ?? '-'),
                      ],
                    ),
                  ),

                  //TODO Out Of Office =============================================================================

                  const SizedBox(height: 16.0),

                  Divider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),

                  const SizedBox(height: 16.0),
                  //! CARD 2

                  Container(
                    width: size.width,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7090B0).withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10.0),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Out of office',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: blue400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  //! CARD 3

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7090B0).withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10.0),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hour',
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
                  const SizedBox(height: 16.0),
                  //! CARD 4

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7090B0).withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10.0),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Position',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(data['out']?['lat'] == null ? '-' : "${data['out']?['lat']}, ${data['out']?['long']}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  //! CARD 5

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7090B0).withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10.0),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Distance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(data['out']?['distance'] == null ? '-' : '${data['out']?['distance']} m'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  //! CARD 6

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7090B0).withOpacity(0.2),
                          blurRadius: 20.0,
                          offset: const Offset(0, 10.0),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(data['out']?['status'] ?? '-'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ));
  }
}
