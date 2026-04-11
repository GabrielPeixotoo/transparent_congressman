import 'package:Deputado_Transparente/domain/entities/entities.dart';
import 'package:Deputado_Transparente/ui/svg/svg_icons.dart';

const CongressPersonEntity kTestCongressPerson = CongressPersonEntity(
  id: 1,
  uri: 'https://dadosabertos.camara.leg.br/api/v2/deputados/1',
  name: 'Test Deputy',
  partyAbbreviation: 'PT',
  partyUri: 'https://example.com/pt',
  stateAbbreviation: 'SP',
  legislatureId: 57,
  urlProfilePic: 'https://example.com/pic.jpg',
  email: 'deputy@example.com',
  stateSvg: SvgIcons.spFlag,
);
