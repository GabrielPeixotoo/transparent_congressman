import 'dart:async';
import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/cache/cache.dart';

class HiveAdapter implements CacheTransactions {
  final Completer<Box> _instance = Completer<Box>();

  Future<void> _init() async {
    final Directory dir = await getApplicationSupportDirectory();
    Hive.init(dir.path);

    final box = await Hive.openBox('myBox');
    _instance.complete(box);
  }

  HiveAdapter() {
    _init();
  }

  @override
  Future<void> delete({required String key}) async {
    final box = await _instance.future;

    try {
      await box.delete(key);
    } catch (error) {
      throw Exception();
    }
  }

  @override
  Future<String> load({required String key}) async {
    final box = await _instance.future;

    try {
      return await box.get(key) ?? '';
    } catch (error) {
      throw Exception();
    }
  }

  @override
  Future<void> save({required String key, required String value}) async {
    final box = await _instance.future;

    try {
      await box.put(key, value);
    } catch (error) {
      throw Exception();
    }
  }
}
