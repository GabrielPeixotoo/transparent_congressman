// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Transparent Congress';

  @override
  String get homeWelcomeTitle =>
      'Welcome! This app helps you review Brazilian federal deputies\' office expenses.';

  @override
  String get homeSearchActiveHint =>
      'Keep typing — results update after a short pause. Tap X or clear the field to show everyone again.';

  @override
  String get homeSearchClearTooltip => 'Clear search';

  @override
  String get homeSearchFieldHint => 'Search deputy by name';

  @override
  String get homeEmptyFilterResults => 'No results match this filter.';

  @override
  String get retry => 'Try again';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get applyFilter => 'Apply filter';

  @override
  String get filters => 'Filters';

  @override
  String get clearFilter => 'Clear filter';

  @override
  String get expensesIntro =>
      'Here are the last six months of expense entries for this deputy:';

  @override
  String get expensesNoData => 'Not enough data to display.';

  @override
  String get documentUnavailable => 'Document unavailable';

  @override
  String expensesPeriodTotal(String total) {
    return 'Period total: $total';
  }

  @override
  String get errorNetwork =>
      'No connection. Check your internet and try again.';

  @override
  String errorServer(int statusCode) {
    return 'Service unavailable ($statusCode). Please try again.';
  }

  @override
  String get errorNotFound => 'Resource not found.';

  @override
  String get errorParse => 'Could not read the response data.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get documentViewerTitle => 'Document';

  @override
  String get stateAll => 'All';
}
