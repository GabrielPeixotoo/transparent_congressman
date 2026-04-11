import 'package:Deputado_Transparente/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import '../ui/theme/theme.dart';
import 'factories/factories.dart';
import 'routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supported) {
        if (locale != null && locale.languageCode == 'pt') {
          return const Locale('pt');
        }
        return const Locale('en');
      },
      localeListResolutionCallback: (locales, supported) {
        final list = locales ?? const <Locale>[];
        if (list.isEmpty) return const Locale('en');
        return list.first.languageCode == 'pt' ? const Locale('pt') : const Locale('en');
      },
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
        GetPage(name: AppRoutes.congressExpenseDetails, page: makeCongressPersonExpensePageFactory),
      ],
    );
  }
}
