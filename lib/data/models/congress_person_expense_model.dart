import '../../domain/entities/entities.dart';

class CongressPersonExpenseModel extends CongressPersonExpenseEntity {
  const CongressPersonExpenseModel(
      {required super.tipoDespesa,
      required super.valorLiquido,
      required super.ano,
      required super.mes,
      required super.urlDocumento});

  factory CongressPersonExpenseModel.fromMap({required Map json}) {
    try {
      return CongressPersonExpenseModel(
        ano: json['ano']?.toString() ?? '',
        mes: json['mes']?.toString() ?? '',
        tipoDespesa: json['tipoDespesa']?.toString() ?? '',
        valorLiquido: json['valorLiquido']?.toString() ?? '',
        urlDocumento: json['urlDocumento']?.toString() ?? '',
      );
    } on TypeError catch (error) {
      throw Exception(error);
    }
  }

  CongressPersonExpenseEntity toEntity() => CongressPersonExpenseEntity(
        tipoDespesa: tipoDespesa,
        valorLiquido: valorLiquido,
        ano: ano,
        mes: mes,
        urlDocumento: urlDocumento,
      );
}
