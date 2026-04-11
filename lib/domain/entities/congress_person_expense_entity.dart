import 'package:equatable/equatable.dart';

class CongressPersonExpenseEntity extends Equatable {
  final String tipoDespesa;
  final String valorLiquido;
  final String ano;
  final String mes;
  final String urlDocumento;
  const CongressPersonExpenseEntity({
    required this.tipoDespesa,
    required this.valorLiquido,
    required this.ano,
    required this.mes,
    required this.urlDocumento,
  });

  @override
  List get props => [
        tipoDespesa,
        valorLiquido,
        ano,
        mes,
        urlDocumento,
      ];
}
