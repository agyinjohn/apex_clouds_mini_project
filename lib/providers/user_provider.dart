import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/sign_up_method.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get getUser => _user!;
  Future<void> refreshUser() async {
    User? user = await Authentication().getUserDetails();
    _user = user;
    notifyListeners();
  }
}
