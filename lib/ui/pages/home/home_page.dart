import 'dart:async';

import 'package:Deputado_Transparente/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../theme/theme.dart';
import '../components/components.dart';
import 'components/components.dart';
import 'home_presenter.dart';

class HomePage extends StatefulWidget {
  final HomePresenter presenter;
  const HomePage({Key? key, required this.presenter}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Duration _searchDebounce = Duration(milliseconds: 500);

  late TextEditingController searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    widget.presenter.fetchCongressPersons();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  BrazilianState selectedState = BrazilianState.states[0];

  void onChangedTextField(String value) {
    _debounce?.cancel();
    setState(() {});

    if (searchController.text.isEmpty) {
      widget.presenter.fetchCongressPersons();
      return;
    }

    _debounce = Timer(_searchDebounce, () {
      if (!mounted) return;
      final query = searchController.text.trim();
      if (query.isEmpty) {
        widget.presenter.fetchCongressPersons();
        return;
      }
      widget.presenter.searchCongressPersonByName(name: query);
    });
  }

  void clearSearchField() {
    closeKeyboard();
    _debounce?.cancel();
    searchController.clear();
    setState(() {});
    widget.presenter.fetchCongressPersons();
  }

  void clearControllerAndRemoveFilters() => setState(() {
        selectedState = BrazilianState.states[0];
        _debounce?.cancel();
        searchController.clear();
        widget.presenter.fetchCongressPersons();
      });

  void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final hasSearchText = searchController.text.isNotEmpty;
    final topLabel = hasSearchText ? l10n.homeSearchActiveHint : l10n.homeWelcomeTitle;

    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomBodyTop(
                size: size,
                childSize: 54,
                label: topLabel,
                child: HomeSearchBar(
                  controller: searchController,
                  onChanged: onChangedTextField,
                  onClear: clearSearchField,
                ),
              ),
              HomeCongressPersonStreamBody(
                stream: widget.presenter.congressPersonStream,
                onRetry: () => widget.presenter.fetchCongressPersons(),
                onCongressPersonTap: (congressPerson) {
                  widget.presenter.navigateToExpenses(congressPerson: congressPerson);
                },
                unfocus: closeKeyboard,
              ),
            ],
          ),
          floatingActionButton: Visibility(
            visible: searchController.text.isNotEmpty || selectedState != BrazilianState.states[0],
            replacement: FloatingActionButton.extended(
              onPressed: () => UIHelper.showCustomBottomSheet(
                bottomSheet: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setSheetState) {
                    return HomeStateFilterSheet(
                      selectedState: selectedState,
                      onStateChanged: (value) {
                        setSheetState(() {
                          selectedState = value;
                        });
                        setState(() {});
                      },
                      onClearFilters: () {
                        closeKeyboard();
                        Navigator.pop(context);
                        widget.presenter.fetchCongressPersons();
                        setSheetState(() {
                          selectedState = BrazilianState.states[0];
                        });
                        setState(() {
                          selectedState = BrazilianState.states[0];
                        });
                      },
                      onApplyFilter: () {
                        closeKeyboard();
                        Navigator.pop(context);
                        widget.presenter.searchCongressPersonByState(state: selectedState.name);
                      },
                    );
                  },
                ),
              ),
              label: Text(l10n.filters),
              icon: const Icon(Icons.filter_alt_off_rounded),
              backgroundColor: AppColors.secondaryColor,
            ),
            child: FloatingActionButton.extended(
              onPressed: clearControllerAndRemoveFilters,
              label: Text(l10n.clearFilter),
              icon: const Icon(Icons.filter_alt_off_rounded),
              backgroundColor: AppColors.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
