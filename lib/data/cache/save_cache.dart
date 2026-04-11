abstract class CacheTransactions {
  Future<void> save({
    required String key,
    required String value,
  });

  Future<void> load({
    required String key,
  });

  Future<void> delete({
    required String key,
  });
}
