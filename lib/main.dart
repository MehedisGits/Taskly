import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/utils/color_scheme.dart';
import 'package:task_manager/views/dashboard.dart';

void main ()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Taskly',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,

      home: DashboardScreen(),
    );
  }
}
