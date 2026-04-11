import 'package:Deputado_Transparente/domain/errors/failure.dart';
import 'package:Deputado_Transparente/domain/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Ok fold invokes ok branch', () {
    const Result<int> r = Ok(21);
    expect(r.fold(ok: (v) => v * 2, err: (_) => -1), 42);
  });

  test('Err fold invokes err branch', () {
    const Result<int> r = Err(NetworkFailure());
    expect(r.fold(ok: (_) => 1, err: (_) => 2), 2);
  });
}
