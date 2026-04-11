// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Deputado Transparente';

  @override
  String get homeWelcomeTitle =>
      'Bem-vindo(a) ao seu app de fiscalização de gastos dos deputados federais!';

  @override
  String get homeSearchActiveHint =>
      'Continue digitando — a busca atualiza após uma pausa. Toque no X ou apague o campo para ver todos de novo.';

  @override
  String get homeSearchClearTooltip => 'Limpar busca';

  @override
  String get homeSearchFieldHint => 'Pesquise o nome do deputado';

  @override
  String get homeEmptyFilterResults =>
      'Nenhum resultado foi encontrado com esse filtro.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get clearFilters => 'Limpar filtros';

  @override
  String get applyFilter => 'Aplicar filtro';

  @override
  String get filters => 'Filtros';

  @override
  String get clearFilter => 'Limpar filtro';

  @override
  String get expensesIntro =>
      'Aqui ficam contemplados os gastos nos últimos 6 meses do seguinte deputado:';

  @override
  String get expensesNoData => 'Não há dados suficientes.';

  @override
  String get documentUnavailable => 'Documento indisponível';

  @override
  String expensesPeriodTotal(String total) {
    return 'Total do periodo: $total';
  }

  @override
  String get errorNetwork =>
      'Sem conexão. Verifique a internet e tente novamente.';

  @override
  String errorServer(int statusCode) {
    return 'Serviço indisponível ($statusCode). Tente novamente.';
  }

  @override
  String get errorNotFound => 'Recurso não encontrado.';

  @override
  String get errorParse => 'Não foi possível interpretar os dados recebidos.';

  @override
  String get errorUnknown => 'Algo deu errado. Tente novamente.';

  @override
  String get documentViewerTitle => 'Documento';

  @override
  String get stateAll => 'Todos';
}
