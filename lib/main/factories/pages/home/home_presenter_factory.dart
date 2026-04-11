import '../../usecases/usecases.dart';

import '../../../../presentation/presentation.dart';
import '../../../../ui/pages/pages.dart';

HomePresenter makeHomePresenter() => GetXHomePresenter(
    fetchCongressPersonsUseCase: makeFetchCongressPersonUseCase());
