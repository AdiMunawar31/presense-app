import 'package:d2ypresence/app/common/styles.dart';
import 'package:d2ypresence/app/controllers/page_index_controller.dart';
import 'package:d2ypresence/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Get.put(PageIndexController(), permanent: true);

  runApp(
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          print(snapshot.data);
          return GetMaterialApp(
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
            initialRoute: snapshot.data != null ? Routes.HOME : Routes.LOGIN,
            getPages: AppPages.routes,
          );
        }),
  );
}
