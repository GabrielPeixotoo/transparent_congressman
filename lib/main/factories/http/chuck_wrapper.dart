import 'package:chuck_interceptor/chuck_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'http.dart';

class ChuckWrapper implements IChuck {
  ChuckWrapper(this._inner);
  final Chuck _inner;

  @override
  Interceptor get dioInterceptor => _inner.dioInterceptor;

  @override
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _inner.setNavigatorKey(navigatorKey);
  }
}
