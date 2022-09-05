import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/models/login_response.dart';
import 'package:chat/globals/environment.dart';
import 'package:chat/models/user.dart';

class AuthService with ChangeNotifier {
  late User user;
  bool _loadingAuth = false;
  final _storage = const FlutterSecureStorage();

  bool get loadingAuth => _loadingAuth;

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token',aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
        iOptions: const IOSOptions(
        accountName: null,
      ));
  }

  set loadingAuth(bool value) {
    _loadingAuth = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    loadingAuth = true;

    final data = {'email': email, 'password': password};
    final uri =
        Uri(scheme: 'https', host: Environment.host, path: Environment.apiPath);

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    print(response.body);
    loadingAuth = false;

    if (response.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      return true;
    }

    return false;
  }

  Future register(String name, String email, String password) async {
    loadingAuth = true;

    final data = {'name': name, 'email': email, 'password': password};
    final Uri url =
        Uri(scheme: 'https', host: Environment.host, path: 'api/new');

    final res = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    loadingAuth = false;

    if (res.statusCode == 200) {
      //print(res.body);
      final loginResponse = LoginResponse.fromJson(jsonDecode(res.body));
      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      return true;
    }
    final error = jsonDecode(res.body);
    return error['msg'];
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(
        key: 'token',
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
    //final data = {};
    final Uri url =
        Uri(scheme: 'https', host: Environment.host, path: 'api/renew');

    final res = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'x-token': '$token'},
    );

    print(res.body);

    if (res.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(jsonDecode(res.body));
      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      await logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    //* aqui va un return
    return await _storage.write(
        key: 'token',
        value: token,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
  }

  Future logout() async {
    await _storage.delete(
        key: 'token',
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  IOSOptions _getIOSOptions() => IOSOptions(
        accountName: null,
      );
}
