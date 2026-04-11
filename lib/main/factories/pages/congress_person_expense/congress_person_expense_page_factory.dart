import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import '../pages.dart';

Widget makeCongressPersonExpensePageFactory() => CongressPersonExpensePage(
      presenter: makeCongressPersonExpensePresenter(),
    );
