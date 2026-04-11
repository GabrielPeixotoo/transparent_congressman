import 'package:Deputado_Transparente/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/entities.dart';
import '../../../helpers/helpers.dart';
import '../../../theme/theme.dart';
import '../../components/components.dart';
import '../home_view_state.dart';

class HomeCongressPersonStreamBody extends StatelessWidget {
  const HomeCongressPersonStreamBody({
    super.key,
    required this.stream,
    required this.onRetry,
    required this.onCongressPersonTap,
    required this.unfocus,
  });

  final Stream<HomeViewState> stream;
  final VoidCallback onRetry;
  final void Function(CongressPersonEntity congressPerson) onCongressPersonTap;
  final VoidCallback unfocus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<HomeViewState>(
      stream: stream,
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
                          unfocus();
                          onCongressPersonTap(congressPerson);
                        },
                        child: Card(
                          child: CustomCongressPersonCard(
                            congressPerson: congressPerson,
                          ),
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
                        onPressed: onRetry,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        };
      },
    );
  }
}
