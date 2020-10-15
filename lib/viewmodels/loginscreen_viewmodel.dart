import 'package:flutter/cupertino.dart';
import 'package:saber/actors/contracts/AuthenticationActorContract.dart';
import 'package:saber/domain/models/auth_model.dart';
import 'package:saber/domain/models/user_model.dart';
import 'package:saber/providers/AuthenticationProvider.dart';

class LoginScreenViewModel extends ChangeNotifier {
  AuthenticationActorContract authenticationActor;

  AuthenticationProvider authenticationProvider;

  bool authenticated = false;

  bool loginWorking = false;

  String _username;

  String _serverURI;

  get serverURI => _serverURI;

  set serverURI(String uri){
    _serverURI = uri;
  }

  get username => _username;

  set username(String text) {
    _username = text;
  }

  String _password;

  get password => _password;

  set password(String text) {
    _password = text;
  }

  LoginScreenViewModel({this.authenticationProvider, this.authenticationActor});

  Future<bool> login() async {
    _setLoginWorking(true);
    authenticationProvider.authModelStore.clear();
    bool loggedIn = await authenticationActor.login(_username, _password, serverURI);
    debugPrint("FLUTTER_VM: LOGGED_IN: ${loggedIn}");
    if (loggedIn) {
      AuthModel authModel = AuthModel(
          userModel: UserModel(
              username: _username, phoneNumber: username, password: password, serverURI: serverURI),
          authenticated: true);
      authenticationProvider.setAuthModel(authModel);
      authenticationProvider.authModelStore.putObject("user-auth", authModel);
      return true;
    } else {
      _setLoginWorking(false);
      return false;
    }
  }

  _setLoginWorking(bool state) {
    loginWorking = state;
    notifyListeners();
  }
}
