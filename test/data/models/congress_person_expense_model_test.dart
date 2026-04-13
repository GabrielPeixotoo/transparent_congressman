import 'package:Deputado_Transparente/data/models/congress_person_expense_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CongressPersonExpenseModel', () {
    test('fromMap maps fields and toEntity preserves values', () {
      final json = <String, dynamic>{
        'tipoDespesa': 'PASSAGEM',
        'valorLiquido': '99.90',
        'ano': '2024',
        'mes': '4',
        'urlDocumento': 'https://example.com/x.pdf',
      };

      final model = CongressPersonExpenseModel.fromMap(json: json);
      expect(model.tipoDespesa, 'PASSAGEM');
      expect(model.valorLiquido, '99.90');
      expect(model.ano, '2024');
      expect(model.mes, '4');
      expect(model.urlDocumento, 'https://example.com/x.pdf');

      final entity = model.toEntity();
      expect(entity.tipoDespesa, model.tipoDespesa);
      expect(entity.valorLiquido, model.valorLiquido);
      expect(entity.ano, model.ano);
      expect(entity.mes, model.mes);
      expect(entity.urlDocumento, model.urlDocumento);
    });

    test('fromMap uses empty strings for missing keys', () {
      final model =
          CongressPersonExpenseModel.fromMap(json: <String, dynamic>{});

      expect(model.tipoDespesa, '');
      expect(model.valorLiquido, '');
      expect(model.ano, '');
      expect(model.mes, '');
      expect(model.urlDocumento, '');
    });
  });
}
