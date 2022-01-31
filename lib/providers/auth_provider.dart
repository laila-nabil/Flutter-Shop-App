import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../helpers/globals.dart' as globals;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        // 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=${env['API_KEY']}';
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=${globals.apiKey}';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      var _error = json.decode(response.body)['error'];
      if (_error != null) {
        throw HttpException(_error['message']);
      }
      _token = json.decode(response.body)['idToken'];
      _expiryDate = DateTime.now().add(Duration(
          seconds: int.parse(json.decode(response.body)['expiresIn'])));
      _userId = json.decode(response.body)['localId'];
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        return false;
      } else {
        final extractedUserData =
            json.decode(prefs.getString('userData')) as Map<String, dynamic>;
        final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
        if (expiryDate.isBefore(DateTime.now())) {
          return false;
        } else {
          _token = extractedUserData['token'];
          _userId = extractedUserData['userId'];
          _expiryDate = expiryDate;
          notifyListeners();
          _autoLogout();
          return true;
        }
      }
    } catch (error) {
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
