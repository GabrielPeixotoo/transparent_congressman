import 'package:Deputado_Transparente/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final hasText = controller.text.isNotEmpty;
        return Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
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
            if (hasText)
              IconButton(
                tooltip: l10n.homeSearchClearTooltip,
                icon: const Icon(Icons.close),
                onPressed: onClear,
              )
            else
              const IconButton(
                icon: Icon(Icons.search),
                onPressed: null,
              ),
          ],
        );
      },
    );
  }
}
