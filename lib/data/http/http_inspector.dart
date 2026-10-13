import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class HttpInspector {
  Interceptor get dioInterceptor;

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey);
}
