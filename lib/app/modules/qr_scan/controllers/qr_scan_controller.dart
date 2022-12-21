import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

class QrScanController extends GetxController {
  TextEditingController qrContentEditingController = TextEditingController();

  var qrCode = ''.obs;
  String scannedQr = '';

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> scanQR() async {
    try {
      scannedQr = await FlutterBarcodeScanner.scanBarcode('#37B6F8', 'Cancel', true, ScanMode.QR);
      Get.snackbar('QR CODE RESULT', 'Qr : $scannedQr');
    } on PlatformException {}
  }
}
