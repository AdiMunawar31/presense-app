import 'package:d2ypresence/app/common/styles.dart';
import 'package:d2ypresence/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: primaryColor,
    systemNavigationBarColor: primaryColor,
  ));

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "d2ypresence",
      theme: ThemeData(
        colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: Colors.white,
            ),
        scaffoldBackgroundColor: secondaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      initialRoute: Routes.LOGIN,
      getPages: AppPages.routes,
    ),
  );
}
