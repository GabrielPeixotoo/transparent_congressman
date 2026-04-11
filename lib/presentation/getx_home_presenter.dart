import 'dart:async';
import 'package:get/get.dart';

import '../domain/entities/entities.dart';
import '../domain/usecases/usecases.dart';
import '../main/routes/routes.dart';
import '../ui/pages/pages.dart';

class GetXHomePresenter implements HomePresenter {
  final FetchCongressPeopleUseCase fetchCongressPersonsUseCase;
  GetXHomePresenter({
    required this.fetchCongressPersonsUseCase,
  });

  final Rx<List<CongressPersonEntity>?> _congressPersons =
      Rx<List<CongressPersonEntity>?>([]);

  @override
  Stream<List<CongressPersonEntity>?> get congressPersonStream =>
      _congressPersons.stream;

  @override
  Future<void> fetchCongressPersons() async {
    try {
      final FetchCongressPeopleParams params = FetchCongressPeopleParams.all();
      final listOfCongressPerson = await fetchCongressPersonsUseCase.call(
        params: params,
      );
      _congressPersons.subject.add(listOfCongressPerson);
    } catch (e) {}
  }

  @override
  Future<void> searchCongressPersonByName({required String name}) async {
    try {
      if (name.isNotEmpty) {
        _congressPersons.subject.add(null);
        final FetchCongressPeopleParams params =
            FetchCongressPeopleParams(nome: name);
        final listOfCongressPerson = await fetchCongressPersonsUseCase.call(
          params: params,
        );
        _congressPersons.subject.add(listOfCongressPerson);
      }
    } catch (e) {}
  }

  @override
  Future<void> searchCongressPersonByState({required String state}) async {
    try {
      if (state.isNotEmpty) {
        _congressPersons.subject.add(null);
        final FetchCongressPeopleParams params =
            FetchCongressPeopleParams(siglaUf: state);
        final listOfCongressPerson = await fetchCongressPersonsUseCase.call(
          params: params,
        );
        _congressPersons.subject.add(listOfCongressPerson);
      }
    } catch (e) {}
  }

  @override
  void navigateToExpenses({required CongressPersonEntity congressPerson}) {
    Get.toNamed(
      AppRoutes.congressExpenseDetails,
      arguments: {'congressPerson': congressPerson},
    );
  }
}
