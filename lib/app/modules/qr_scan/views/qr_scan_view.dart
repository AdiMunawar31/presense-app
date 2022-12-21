import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/qr_scan_controller.dart';

class QrScanView extends GetView<QrScanController> {
  const QrScanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR CODE SCANNER'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            controller.scanQR();
          },
          child: Text(
            'Scan QR Code',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
