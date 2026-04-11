import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/ui_helper.dart';
import '../../theme/theme.dart';
import '../components/components.dart';
import '../pages.dart';
import 'components/components.dart';

class CongressPersonExpensePage extends StatefulWidget {
  final CongressPersonExpensePresenter presenter;
  const CongressPersonExpensePage({required this.presenter, Key? key})
      : super(key: key);

  @override
  State<CongressPersonExpensePage> createState() =>
      _CongressPersonExpensePageState();
}

class _CongressPersonExpensePageState extends State<CongressPersonExpensePage> {
  late CongressPersonEntity congressPerson;

  @override
  void initState() {
    super.initState();
    congressPerson = Get.arguments['congressPerson'] as CongressPersonEntity;
    widget.presenter
        .fetchCongressPersonExpense(id: congressPerson.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: AppColors.primaryColor,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(elevation: 0),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomBodyTop(
              size: size,
              childSize: 68,
              label:
                  'Aqui ficam contemplados os gastos nos últimos 6 meses do seguinte deputado:',
              child: Hero(
                tag: congressPerson.id,
                child: Material(
                  child:
                      CustomCongressPersonCard(congressPerson: congressPerson),
                ),
              ),
            ),
            StreamBuilder<List<CongressPersonExpenseEntity?>?>(
              stream: widget.presenter.congressPersonExpenseStream,
              builder: (context, snapshot) {
                final snapshotData = snapshot.data;
                if (snapshotData == null) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  final listOfCongressPerson = snapshot.data ?? [];
                  final expensesSum = listOfCongressPerson.fold<double>(
                      0, (e, t) => e + double.parse(t?.valorLiquido ?? '0'));
                  final formattedExpenseSum =
                      UtilBrasilFields.obterReal(expensesSum);

                  return Expanded(
                    child: Column(
                      children: [
                        Visibility(
                          visible: listOfCongressPerson.isNotEmpty,
                          replacement: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Não há dados suficientes.'),
                          ),
                          child: Expanded(
                            child: ListView.builder(
                                itemCount: listOfCongressPerson.length,
                                itemBuilder: (context, index) {
                                  final congressPersonExpense =
                                      listOfCongressPerson[index]!;
                                  final formattedLiquidValue =
                                      UtilBrasilFields.obterReal(double.parse(
                                          congressPersonExpense.valorLiquido));
                                  return InkWell(
                                    onTap: () {
                                      final urlDocument =
                                          congressPersonExpense.urlDocumento;
                                      if (urlDocument.isNotEmpty) {
                                        if (urlDocument.contains('.pdf')) {
                                          Get.to(() => PdfViewerWidget(
                                                document: urlDocument,
                                              ));
                                        } else {
                                          _launchInWebView(
                                              Uri.parse(urlDocument));
                                        }
                                      } else {
                                        UIHelper.showCustomSnackBar(
                                          title: 'Documento indisponível',
                                          titleColor: Colors.white,
                                          backgroundColor:
                                              AppColors.primaryColor,
                                        );
                                      }
                                    },
                                    child: Card(
                                      child: ListTile(
                                        leading: const Icon(Icons.money),
                                        title: Text(
                                          congressPersonExpense.tipoDespesa,
                                          style: AppTextStyle.poppins2,
                                        ),
                                        subtitle: Text(
                                          formattedLiquidValue,
                                          style: AppTextStyle.poppins2,
                                        ),
                                        trailing: Text(
                                            '${congressPersonExpense.mes}/${congressPersonExpense.ano}'),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Visibility(
                          visible: expensesSum != 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total do periodo: $formattedExpenseSum',
                              style: AppTextStyle.poppins2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchInWebView(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
