import 'package:Deputado_Transparente/data/models/congress_person_model.dart';
import 'package:Deputado_Transparente/ui/svg/svg_icons.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CongressPersonModel', () {
    test('fromMap maps API fields and toEntity preserves values', () {
      final json = <String, dynamic>{
        'id': 123,
        'uri': 'https://dadosabertos.camara.leg.br/api/v2/deputados/123',
        'nome': 'Fulano',
        'siglaPartido': 'PT',
        'uriPartido': 'https://example.com/pt',
        'siglaUf': 'SP',
        'idLegislatura': 57,
        'urlFoto': 'https://example.com/foto.jpg',
        'email': 'a@b.c',
      };

      final model = CongressPersonModel.fromMap(json: json);
      expect(model.id, 123);
      expect(model.uri, json['uri']);
      expect(model.name, 'Fulano');
      expect(model.partyAbbreviation, 'PT');
      expect(model.partyUri, json['uriPartido']);
      expect(model.stateAbbreviation, 'SP');
      expect(model.legislatureId, 57);
      expect(model.urlProfilePic, json['urlFoto']);
      expect(model.email, 'a@b.c');
      expect(model.stateSvg, SvgIcons.spFlag);

      final entity = model.toEntity();
      expect(entity.id, model.id);
      expect(entity.name, model.name);
      expect(entity.stateSvg, model.stateSvg);
    });

    test('toMap round-trips core string fields', () {
      final model = CongressPersonModel.fromMap(json: {
        'id': 1,
        'uri': 'u',
        'nome': 'N',
        'siglaPartido': 'P',
        'uriPartido': 'pu',
        'siglaUf': 'RJ',
        'idLegislatura': 2,
        'urlFoto': 'f',
        'email': 'e',
      });

      final map = model.toMap();
      expect(map['id'], 1);
      expect(map['nome'], 'N');
      expect(map['siglaUf'], 'RJ');
      expect(map['idLegislatura'], 2);
    });

    test('fromMap uses defaults for missing keys', () {
      final model = CongressPersonModel.fromMap(json: <String, dynamic>{});

      expect(model.id, 0);
      expect(model.uri, '');
      expect(model.name, '');
      expect(model.partyAbbreviation, '');
      expect(model.stateAbbreviation, '');
      expect(model.legislatureId, 0);
      expect(model.stateSvg, SvgIcons.brazilFlag);
    });
  });
}
