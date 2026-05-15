import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    final email = prefs.getString('user_email');
    
    if (name != null && email != null) {
      _user = UserModel(
        id: '1',
        name: name,
        email: email,
        phone: prefs.getString('user_phone') ?? '+91 98765 43210',
        profileImage: 'https://i.pravatar.cc/150?u=1',
      );
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _user = UserModel(
      id: '1',
      name: 'Prakash Kumar',
      email: email,
      phone: '+91 98765 43210',
      profileImage: 'https://i.pravatar.cc/150?u=1',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _user!.name);
    await prefs.setString('user_email', _user!.email);
    await prefs.setString('user_phone', _user!.phone);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _user = UserModel(
      id: '1',
      name: name,
      email: email,
      phone: phone,
      profileImage: 'https://i.pravatar.cc/150?u=1',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _user!.name);
    await prefs.setString('user_email', _user!.email);
    await prefs.setString('user_phone', _user!.phone);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
