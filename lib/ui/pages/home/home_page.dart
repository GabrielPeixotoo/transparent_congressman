import 'package:flutter/material.dart';
import 'package:Deputado_Transparente/l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/helpers.dart';
import '../../theme/theme.dart';
import '../components/components.dart';
import '../pages.dart';

class HomePage extends StatefulWidget {
  final HomePresenter presenter;
  const HomePage({Key? key, required this.presenter}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    widget.presenter.fetchCongressPersons();
    super.initState();
  }

  BrazilianState selectedState = BrazilianState.states[0];

  void onChangedTextField(String value) => setState(() {
        if (searchController.text.isEmpty) {
          widget.presenter.fetchCongressPersons();
        }
      });

  void clearControllerAndRemoveFilters() => setState(() {
        selectedState = BrazilianState.states[0];
        searchController.clear();
        widget.presenter.fetchCongressPersons();
      });

  void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final topLabel = searchController.text.isNotEmpty
        ? l10n.homeSearchActiveHint
        : l10n.homeWelcomeTitle;

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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: onChangedTextField,
                        decoration: InputDecoration(
                          hintText: l10n.homeSearchFieldHint,
                          hintStyle: TextStyle(
                            color: AppColors.primaryColor.withOpacity(0.5),
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        closeKeyboard();
                        widget.presenter.searchCongressPersonByName(
                            name: searchController.text);
                      },
                    ),
                  ],
                ),
              ),
              StreamBuilder<HomeViewState>(
                stream: widget.presenter.congressPersonStream,
                builder: (context, snapshot) {
                  final state = snapshot.data ?? const HomeLoading();
                  return switch (state) {
                    HomeLoading() => const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    HomeSuccess(:final items) when items.isEmpty => Center(
                        child: Text(
                          l10n.homeEmptyFilterResults,
                          style: AppTextStyle.poppins2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    HomeSuccess(:final items) => Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final congressPerson = items[index];
                            return Hero(
                              tag: congressPerson.id,
                              child: Material(
                                child: InkWell(
                                  onTap: () {
                                    closeKeyboard();
                                    widget.presenter.navigateToExpenses(
                                      congressPerson: congressPerson,
                                    );
                                  },
                                  child: Card(
                                    child: CustomCongressPersonCard(
                                        congressPerson: congressPerson),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    HomeError(:final failure) => Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  failureUserMessage(failure, l10n),
                                  style: AppTextStyle.poppins2,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      widget.presenter.fetchCongressPersons(),
                                  child: Text(l10n.retry),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  };
                },
              ),
            ],
          ),
          floatingActionButton: Visibility(
            visible: searchController.text.isNotEmpty ||
                selectedState != BrazilianState.states[0],
            replacement: FloatingActionButton.extended(
              onPressed: () => UIHelper.showCustomBottomSheet(
                bottomSheet: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setSheetState) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                DropdownButton<BrazilianState>(
                                    value: selectedState,
                                    items: BrazilianState.states
                                        .map((state) =>
                                            DropdownMenuItem<BrazilianState>(
                                                value: state,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        state.imageUrl,
                                                        width: 35,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        state.name ==
                                                                BrazilianState
                                                                    .allStatesValue
                                                            ? l10n.stateAll
                                                            : state.name,
                                                        style: GoogleFonts
                                                            .poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                    ],
                                                  ),
                                                )))
                                        .toList(),
                                    onChanged: (value) {
                                      setSheetState(() {
                                        selectedState = value!;
                                      });
                                      setState(() {});
                                    }),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    closeKeyboard();
                                    Navigator.pop(context);
                                    widget.presenter.fetchCongressPersons();
                                    setSheetState(() {
                                      selectedState =
                                          BrazilianState.states[0];
                                    });
                                    setState(() {
                                      selectedState =
                                          BrazilianState.states[0];
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 24,
                                  ),
                                  label: Text(l10n.clearFilters),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    closeKeyboard();
                                    Navigator.pop(context);
                                    widget.presenter
                                        .searchCongressPersonByState(
                                            state: selectedState.name);
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_rounded,
                                    size: 24,
                                  ),
                                  label: Text(l10n.applyFilter),
                                ),
                              ),
                            ],
                          )
                        ],
                      ));
                }),
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
