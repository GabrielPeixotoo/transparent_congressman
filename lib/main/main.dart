import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/theme/theme.dart';
import 'factories/factories.dart';
import 'routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: AppRoutes.homePage,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryColor,
        ),
      ),
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      getPages: [
        GetPage(name: AppRoutes.homePage, page: makeHomePage),
        GetPage(
            name: AppRoutes.congressExpenseDetails,
            page: makeCongressPersonExpensePageFactory),
      ],
    );
  }
}
