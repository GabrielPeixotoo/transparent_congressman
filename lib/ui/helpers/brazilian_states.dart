import '../svg/svg.dart';

class BrazilianState {
  final String name;
  final String imageUrl;
  const BrazilianState({
    required this.name,
    required this.imageUrl,
  });

  static const String allStatesValue = '_all';

  static const List<BrazilianState> states = [
    BrazilianState(name: allStatesValue, imageUrl: SvgIcons.brazilFlag),
    BrazilianState(name: 'AC', imageUrl: SvgIcons.acreFlag),
    BrazilianState(name: 'AL', imageUrl: SvgIcons.alagoasFlag),
    BrazilianState(name: 'AP', imageUrl: SvgIcons.amapaFlag),
    BrazilianState(name: 'AM', imageUrl: SvgIcons.amazonasFlag),
    BrazilianState(name: 'BA', imageUrl: SvgIcons.bahiaFlag),
    BrazilianState(name: 'CE', imageUrl: SvgIcons.cearaFlag),
    BrazilianState(name: 'DF', imageUrl: SvgIcons.distritoFederalFlag),
    BrazilianState(name: 'ES', imageUrl: SvgIcons.espiritoSantoFlag),
    BrazilianState(name: 'GO', imageUrl: SvgIcons.goiasFlag),
    BrazilianState(name: 'MA', imageUrl: SvgIcons.maranhaoFlag),
    BrazilianState(name: 'MT', imageUrl: SvgIcons.matoGrossoFlag),
    BrazilianState(name: 'MS', imageUrl: SvgIcons.matoGrossoDoSulFlag),
    BrazilianState(name: 'MG', imageUrl: SvgIcons.minasGeraisFlag),
    BrazilianState(name: 'PA', imageUrl: SvgIcons.paraFlag),
    BrazilianState(name: 'PB', imageUrl: SvgIcons.paraibaFlag),
    BrazilianState(name: 'PR', imageUrl: SvgIcons.paranaFlag),
    BrazilianState(name: 'PE', imageUrl: SvgIcons.pernambucoFlag),
    BrazilianState(name: 'PI', imageUrl: SvgIcons.piauiFlag),
    BrazilianState(name: 'RJ', imageUrl: SvgIcons.rjFlag),
    BrazilianState(name: 'RN', imageUrl: SvgIcons.rioGrandeDoNorteFlag),
    BrazilianState(name: 'RS', imageUrl: SvgIcons.rioGrandeDoSulFlag),
    BrazilianState(name: 'RO', imageUrl: SvgIcons.rondoniaFlag),
    BrazilianState(name: 'RR', imageUrl: SvgIcons.roraimaFlag),
    BrazilianState(name: 'SC', imageUrl: SvgIcons.scFlag),
    BrazilianState(name: 'SP', imageUrl: SvgIcons.spFlag),
    BrazilianState(name: 'SE', imageUrl: SvgIcons.sergipeFlag),
    BrazilianState(name: 'TO', imageUrl: SvgIcons.tocantinsFlag),
  ];

  static BrazilianState get initialBrazilianFlag => states[0];
}

String svgIcon({required String value}) {
  String imageUrl = SvgIcons.brazilFlag;
  for (final state in BrazilianState.states) {
    if (state.name == value) {
      imageUrl = state.imageUrl;
    }
  }
  return imageUrl;
}
