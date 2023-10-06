import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unifit/controllers/account_controller.dart';
import 'package:unifit/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UniFit',
      initialRoute: '/login',
      getPages: appRoutes(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onInit: () {
        Get.put(AccountController());
      },
    );
  }
}
