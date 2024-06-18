import 'dart:convert';
import 'package:bineo/models/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final Future<SharedPreferences> _instance = SharedPreferences.getInstance();
  final _secureStorage = new FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  void saveItem(
    String key,
    dynamic data,
  ) async {
    try {
      final SharedPreferences storage = await _instance;
      final String encodedData = jsonEncode(data);
      await storage.setString(key, encodedData);
    } catch (e) {
      print('ERROR saveItem (localstorage) $e');
    }
  }

  dynamic getItem(
    String key,
  ) async {
    final SharedPreferences storage = await _instance;
    try {
      dynamic data = storage.getString(key);
      return data != null ? jsonDecode(data) : null;
    } catch (e) {
      return null;
    }
  }

  void saveSecureItem(
    String key,
    dynamic data,
  ) async {
    try {
      final String encodedData = jsonEncode(data);
      await _secureStorage.write(key: key, value: encodedData);
    } catch (e) {
      print('ERROR saveSecure (secureStorage) $e');
    }
  }

  dynamic getSecureItem(
    String key,
  ) async {
    try {
      dynamic data = await _secureStorage.read(key: key);
      return data != null ? jsonDecode(data) : null;
    } catch (e) {
      return null;
    }
  }

  Future<Session?> getSession() async {
    final session = await getItem(StorageKey.session);
    if (session != null) {
      return Session.fromMap(session);
    }
    return null;
  }

  void saveSession(Session session) {
    saveItem(StorageKey.session, session.toMap());
  }

  void saveAppVersion(int appVersion) async {
    saveItem(StorageKey.appVersion, appVersion);
  }

  Future<int?> getAppVersion() async {
    final appVersion = await getItem(StorageKey.appVersion);
    return appVersion as int?;
  }

  void saveHasBiometricAuthentication(bool value) {
    saveItem(StorageKey.isBiometricAuthenticated, value);
  }

  Future<bool> getHasBiometricAuthentication() async {
    return await getItem(
      StorageKey.isBiometricAuthenticated,
    );
  }

  void saveDeviceId(String value) async {
    saveSecureItem(StorageKey.deviceId, value);
  }

  Future<String?> getDeviceId() async {
    return await getSecureItem(StorageKey.deviceId);
  }

  void clear() async {
    final SharedPreferences storage = await _instance;
    storage.clear();
  }

  Future removeItem(String key) async {
    final SharedPreferences storage = await _instance;
    storage.remove(key);
  }
}

class StorageKey {
  static const session = 'session';
  static const userPassword = 'userPassword';
  static const appVersion = 'appVersion';
  static const isBiometricAuthenticated = 'isBiometricAuthenticated';
  static const deviceId = 'deviceId';
}
