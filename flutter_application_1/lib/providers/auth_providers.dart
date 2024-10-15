/*
import 'package:flutter/material.dart';
import 'package:foodverse_frontend/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String _token = ''; // Initialize _token with an empty string

  String get token => _token;

  Future<void> register(String email, String password) async {
    try {
      final response = await _authService.register(email, password);
      _token = response['token'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      _token = response['token'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void logout() {
    _token = ''; // Assign an empty string to _token
    notifyListeners();
  }
}
*/

/*import 'package:flutter/material.dart';
import 'package:foodverse1/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String _token;

  String get token => _token;

  Future<void> register(String email, String password) async {
    try {
      final response = await _authService.register(email, password);
      _token = response['token'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      _token = response['token'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
*/