import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:Deputado_Transparente/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../../theme/theme.dart';
import '../components/components.dart';
import '../pages.dart';
import 'components/components.dart';

class CongressPersonExpensePage extends StatefulWidget {
  final CongressPersonExpensePresenter presenter;

  /// When non-null (e.g. in tests), skips [Get.arguments] for the deputy.
  final CongressPersonEntity? congressPersonForTest;

  const CongressPersonExpensePage({
    required this.presenter,
    this.congressPersonForTest,
    Key? key,
  }) : super(key: key);

  @override
  State<CongressPersonExpensePage> createState() =>
      _CongressPersonExpensePageState();
}

class _CongressPersonExpensePageState extends State<CongressPersonExpensePage> {
  late CongressPersonEntity congressPerson;

  @override
  void initState() {
    super.initState();
    congressPerson = widget.congressPersonForTest ??
        Get.arguments['congressPerson'] as CongressPersonEntity;
    widget.presenter
        .fetchCongressPersonExpense(id: congressPerson.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
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
              label: l10n.expensesIntro,
              child: Hero(
                tag: congressPerson.id,
                child: Material(
                  child:
                      CustomCongressPersonCard(congressPerson: congressPerson),
                ),
              ),
            ),
            StreamBuilder<CongressExpenseViewState>(
              stream: widget.presenter.congressPersonExpenseStream,
              builder: (context, snapshot) {
                final state =
                    snapshot.data ?? const CongressExpenseLoading();
                switch (state) {
                  case CongressExpenseLoading():
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    );
                  case CongressExpenseError(:final failure):
                    return Expanded(
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
                                onPressed: () => widget.presenter
                                    .fetchCongressPersonExpense(
                                        id: congressPerson.id.toString()),
                                child: Text(l10n.retry),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  case CongressExpenseSuccess(:final items):
                    final expensesSum = items.fold<double>(
                      0,
                      (e, t) => e + double.parse(t.valorLiquido),
                    );
                    final formattedExpenseSum =
                        UtilBrasilFields.obterReal(expensesSum);
                    return Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: items.isNotEmpty,
                            replacement: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(l10n.expensesNoData),
                            ),
                            child: Expanded(
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final congressPersonExpense = items[index];
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
                                          title: l10n.documentUnavailable,
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
                                          '${congressPersonExpense.mes}/${congressPersonExpense.ano}',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: expensesSum != 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                l10n.expensesPeriodTotal(formattedExpenseSum),
                                style: AppTextStyle.poppins2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                }
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
