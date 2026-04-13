import 'package:equatable/equatable.dart';

class CongressPersonExpenseEntity extends Equatable {
  final String expenseType;
  final String netAmount;
  final String year;
  final String month;
  final String documentUrl;
  const CongressPersonExpenseEntity({
    required this.expenseType,
    required this.netAmount,
    required this.year,
    required this.month,
    required this.documentUrl,
  });

  @override
  List<Object> get props => [
        expenseType,
        netAmount,
        year,
        month,
        documentUrl,
      ];
}
