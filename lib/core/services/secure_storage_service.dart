

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService{
  static const String userKey = 'userKey';
  final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  void storeUserId(String id)async{
   await _flutterSecureStorage.write(key: userKey, value: id, aOptions: _getAndroidOptions());
  }

  Future<String?> getUserId()async=>await _flutterSecureStorage.read(key: userKey, aOptions: _getAndroidOptions());
}