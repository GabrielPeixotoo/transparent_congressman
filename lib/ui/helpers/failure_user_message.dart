import '../../domain/errors/failure.dart';

String failureUserMessage(Failure failure) {
  return switch (failure) {
    NetworkFailure(:final message) =>
      message ?? 'Sem conexão. Verifique a internet e tente novamente.',
    ServerFailure(:final statusCode) =>
      'Serviço indisponível ($statusCode). Tente novamente.',
    NotFoundFailure(:final message) =>
      message ?? 'Recurso não encontrado.',
    ParseFailure(:final message) =>
      message ?? 'Não foi possível interpretar os dados recebidos.',
    UnknownFailure() => 'Algo deu errado. Tente novamente.',
  };
}
