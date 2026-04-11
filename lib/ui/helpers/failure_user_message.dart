import 'package:Deputado_Transparente/l10n/app_localizations.dart';

import '../../domain/errors/failure.dart';

String failureUserMessage(Failure failure, AppLocalizations l10n) {
  return switch (failure) {
    NetworkFailure(:final message) => message ?? l10n.errorNetwork,
    ServerFailure(:final statusCode) => l10n.errorServer(statusCode),
    NotFoundFailure() => l10n.errorNotFound,
    ParseFailure() => l10n.errorParse,
    UnknownFailure() => l10n.errorUnknown,
  };
}
