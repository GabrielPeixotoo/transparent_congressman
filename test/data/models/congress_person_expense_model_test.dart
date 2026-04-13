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
      expect(model.expenseType, 'PASSAGEM');
      expect(model.netAmount, '99.90');
      expect(model.year, '2024');
      expect(model.month, '4');
      expect(model.documentUrl, 'https://example.com/x.pdf');

      final entity = model.toEntity();
      expect(entity.expenseType, model.expenseType);
      expect(entity.netAmount, model.netAmount);
      expect(entity.year, model.year);
      expect(entity.month, model.month);
      expect(entity.documentUrl, model.documentUrl);
    });

    test('fromMap uses empty strings for missing keys', () {
      final model = CongressPersonExpenseModel.fromMap(json: const <String, dynamic>{});

      expect(model.expenseType, '');
      expect(model.netAmount, '');
      expect(model.year, '');
      expect(model.month, '');
      expect(model.documentUrl, '');
    });
  });
}
