import 'package:Deputado_Transparente/domain/errors/failure.dart';
import 'package:Deputado_Transparente/l10n/app_localizations.dart';
import 'package:Deputado_Transparente/ui/helpers/failure_user_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('maps NetworkFailure without message to l10n.errorNetwork', (tester) async {
    late AppLocalizations l10n;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final msg = failureUserMessage(const NetworkFailure(), l10n);
    expect(msg, l10n.errorNetwork);
  });

  testWidgets('maps ServerFailure to l10n.errorServer', (tester) async {
    late AppLocalizations l10n;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final msg = failureUserMessage(const ServerFailure(504), l10n);
    expect(msg, l10n.errorServer(504));
  });
}
