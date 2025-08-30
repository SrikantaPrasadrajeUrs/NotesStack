

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService{
  static const String _userKey = 'userKey';
  final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  void storeUserId(String id)async{
   await _flutterSecureStorage.write(key: _userKey, value: id, aOptions: _getAndroidOptions());
  }

  Future<void> clearStorage()async{
    await _flutterSecureStorage.delete(key: _userKey, aOptions: _getAndroidOptions());
  }

  Future<String?> getUserId()async=>await _flutterSecureStorage.read(key: _userKey, aOptions: _getAndroidOptions());
}