import 'package:Deputado_Transparente/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../helpers/brazilian_states.dart';

class HomeStateFilterSheet extends StatelessWidget {
  const HomeStateFilterSheet({
    super.key,
    required this.selectedState,
    required this.onStateChanged,
    required this.onClearFilters,
    required this.onApplyFilter,
  });

  final BrazilianState selectedState;
  final ValueChanged<BrazilianState> onStateChanged;
  final VoidCallback onClearFilters;
  final VoidCallback onApplyFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.18,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  DropdownButton<BrazilianState>(
                    value: selectedState,
                    items: BrazilianState.states
                        .map(
                          (state) => DropdownMenuItem<BrazilianState>(
                            value: state,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    state.imageUrl,
                                    width: 35,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    state.name == BrazilianState.allStatesValue ? l10n.stateAll : state.name,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) onStateChanged(value);
                    },
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onClearFilters,
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    label: Text(l10n.clearFilters),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApplyFilter,
                    icon: const Icon(
                      Icons.filter_alt_rounded,
                      size: 24,
                    ),
                    label: Text(l10n.applyFilter),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
