import '../../../domain/entities/entities.dart';

import 'home_view_state.dart';

abstract class HomePresenter {
  Stream<HomeViewState> get congressPersonStream;

  Future<void> fetchCongressPersons();
  Future<void> searchCongressPersonByName({required String name});
  Future<void> searchCongressPersonByState({required String state});
  void navigateToExpenses({required CongressPersonEntity congressPerson});
}
