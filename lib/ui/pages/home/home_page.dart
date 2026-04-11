import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/entities/entities.dart';
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

  final String initialLabel =
      'Bem-vindo(a) ao seu app de fiscalização de gastos dos deputados federais!';
  final String iconLabel =
      'Toque no ícone de busca para filtrar, ou limpe o campo para retornar a todos os resultados.';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                label:
                    searchController.text.isNotEmpty ? iconLabel : initialLabel,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: onChangedTextField,
                        decoration: InputDecoration(
                          hintText: "Pesquise o nome do deputado",
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
              StreamBuilder<List<CongressPersonEntity?>?>(
                stream: widget.presenter.congressPersonStream,
                builder: (context, snapshot) {
                  final listOfCongressPerson = snapshot.data;
                  if (listOfCongressPerson != null &&
                      listOfCongressPerson.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: listOfCongressPerson.length,
                          itemBuilder: (context, index) {
                            final congressPerson = listOfCongressPerson[index]!;
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
                          }),
                    );
                  } else if (listOfCongressPerson != null &&
                      listOfCongressPerson.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhum resultado foi encontrado com esse filtro.',
                        style: AppTextStyle.poppins2,
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    );
                  }
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
                    builder: (BuildContext context, StateSetter setState) {
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
                                                      Text(state.name,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                    ],
                                                  ),
                                                )))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedState = value!;
                                      });
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
                                    setState(() {
                                      selectedState = BrazilianState.states[0];
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 24,
                                  ),
                                  label: const Text("Limpar filtros"),
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
                                  label: const Text("Aplicar filtro"),
                                ),
                              ),
                            ],
                          )
                        ],
                      ));
                }),
              ),
              label: const Text('Filtros'),
              icon: const Icon(Icons.filter_alt_off_rounded),
              backgroundColor: AppColors.secondaryColor,
            ),
            child: FloatingActionButton.extended(
              onPressed: clearControllerAndRemoveFilters,
              label: const Text('Limpar filtro'),
              icon: const Icon(Icons.filter_alt_off_rounded),
              backgroundColor: AppColors.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
