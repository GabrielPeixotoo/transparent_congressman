import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../data/http/http.dart';

abstract class IChuck {
  Interceptor get dioInterceptor;
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey);
}

class ChuckAdapter extends HttpInspector {
  ChuckAdapter({required this.chuck});

  final IChuck chuck;

  @override
  Interceptor get dioInterceptor => chuck.dioInterceptor;

  @override
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    chuck.setNavigatorKey(navigatorKey);
  }
}
