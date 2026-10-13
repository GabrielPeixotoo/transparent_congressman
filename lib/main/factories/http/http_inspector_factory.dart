import 'package:chuck_interceptor/chuck_interceptor.dart';

import '../../../data/http/http.dart';
import '../factories.dart';

final _chuck = ChuckWrapper(
  Chuck(
    showInspectorOnShake: true,
  ),
);

HttpInspector makeHttpInspector() => ChuckAdapter(
      chuck: _chuck,
    );
