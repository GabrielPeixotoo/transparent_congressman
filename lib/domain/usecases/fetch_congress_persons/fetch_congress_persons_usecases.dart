import '../../entities/entities.dart';

abstract class FetchCongressPeopleUseCase {
  Future<List<CongressPersonEntity>> call({
    required FetchCongressPeopleParams params,
  });
}

class FetchCongressPeopleParams {
  final String? nome;
  final String? ordem;
  final String? ordenarPor;
  final String? siglaUf;
  FetchCongressPeopleParams({
    this.nome,
    this.ordem,
    this.ordenarPor,
    this.siglaUf,
  });

  FetchCongressPeopleParams.all({
    this.nome,
    this.ordem = 'ASC',
    this.ordenarPor = 'nome',
    this.siglaUf = '',
  });
}
