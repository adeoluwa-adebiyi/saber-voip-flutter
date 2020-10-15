import 'package:flutter/cupertino.dart';
import 'package:saber/providers/AuthenticationProvider.dart';

class SplashScreenViewModel extends ChangeNotifier{

  AuthenticationProvider authenticationProvider;

  SplashScreenViewModel({@required this.authenticationProvider});

  bool authenticated = false;

  getAuthenticated(){
    return authenticated;
  }

  setAuthenticated(bool status){
    authenticated = status;
    notifyListeners();
  }

  checkUserLoggedIn(){
    if(authenticationProvider.getAuthModel() != null && authenticationProvider.getAuthModel().authenticated != null){
      setAuthenticated(authenticationProvider.getAuthModel().authenticated);
    }else{
      setAuthenticated(false);
    }
  }

}