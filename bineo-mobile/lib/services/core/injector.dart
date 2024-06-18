class Injector {
  Injector._();

  static final _map = <String, Function>{};
  static final _objectsMap = <String, dynamic>{};

  static T resolve<T>() {
    if (_objectsMap[T.toString()] == null) {
      _objectsMap[T.toString()] = _map[T.toString()]?.call();
    }
    return _objectsMap[T.toString()] as T;
  }

  static T register<T>(Function injectableFunction) {
    _map[T.toString()] = injectableFunction;
    return resolve<T>();
  }

  static void clearAll() {
    _objectsMap.clear();
  }

  static void clear<T>() {
    if (_objectsMap.containsKey(T.toString())) {
      _objectsMap[T.toString()] = null;
    }
  }
}
