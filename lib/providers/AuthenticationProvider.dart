import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:saber/domain/models/auth_model.dart';
import 'package:saber/stores/HiveStore.dart';

class AuthenticationProvider with ChangeNotifier{
  String _authModelKey = "user-auth";

  AuthModelStore authModelStore;

  AuthModel _authModel;

  AuthenticationProvider({this.authModelStore});

  get authModelKey => _authModelKey;

  AuthModel getAuthModel(){
    var model = authModelStore.getObject(_authModelKey);
    if(model == null){
      authModelStore.putObject(_authModelKey, AuthModel());
    }
    setAuthModel(authModelStore.getObject(_authModelKey));
    return _authModel;
  }

  setAuthModel(AuthModel model){
    _authModel = model;
    notifyListeners();
  }
}