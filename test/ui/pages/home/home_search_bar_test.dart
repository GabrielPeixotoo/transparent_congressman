import 'package:Deputado_Transparente/l10n/app_localizations.dart';
import 'package:Deputado_Transparente/ui/pages/home/components/home_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('search icon when empty; clear icon after typing', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: HomeSearchBar(
            controller: controller,
            onChanged: (_) {},
            onClear: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);

    await tester.enterText(find.byType(TextField), 'Silva');
    await tester.pump();

    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('onClear is invoked when clear icon is tapped', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    var cleared = false;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: HomeSearchBar(
            controller: controller,
            onChanged: (_) {},
            onClear: () => cleared = true,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'x');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(cleared, isTrue);
  });
}
