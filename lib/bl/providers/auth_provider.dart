import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/enums/auth_status.dart';

class AuthProvider with ChangeNotifier {
  update() {}

  AuthStatus _authStatus = AuthStatus.unknown;

  AuthStatus get authStatus {
    return _authStatus;
  }

  login() {
    _authStatus = AuthStatus.loggedIn;
    log("Logged in");
    notifyListeners();
  }
}
