
import '../../../domain/entities/entities.dart';

abstract class HomePresenter {
  Stream<List<CongressPersonEntity>?> get congressPersonStream;

  Future<void> fetchCongressPersons();
  Future<void> searchCongressPersonByName({required String name});
  Future<void> searchCongressPersonByState({required String state});
  void navigateToExpenses({required CongressPersonEntity congressPerson});
}
