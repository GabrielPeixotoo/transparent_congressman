import '../../domain/entities/entities.dart';

class CongressPersonExpenseModel extends CongressPersonExpenseEntity {
  const CongressPersonExpenseModel({
    required super.expenseType,
    required super.netAmount,
    required super.year,
    required super.month,
    required super.documentUrl,
  });

  factory CongressPersonExpenseModel.fromMap({required Map json}) {
    try {
      return CongressPersonExpenseModel(
        year: json['ano']?.toString() ?? '',
        month: json['mes']?.toString() ?? '',
        expenseType: json['tipoDespesa']?.toString() ?? '',
        netAmount: json['valorLiquido']?.toString() ?? '',
        documentUrl: json['urlDocumento']?.toString() ?? '',
      );
    } on TypeError catch (error) {
      throw Exception(error);
    }
  }

  CongressPersonExpenseEntity toEntity() => CongressPersonExpenseEntity(
        expenseType: expenseType,
        netAmount: netAmount,
        year: year,
        month: month,
        documentUrl: documentUrl,
      );
}
