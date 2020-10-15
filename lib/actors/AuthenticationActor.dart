import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saber/constants/server_connection_settings.dart';
import 'package:saber/domain/models/auth_model.dart';
import 'package:saber/providers/AuthenticationProvider.dart';
import 'package:saber/providers/NativeSIPApiProvider.dart';
import 'contracts/AuthenticationActorContract.dart';


//final PACKAGE_NAME = "methods";

class AuthenticationActor implements AuthenticationActorContract {

  AuthenticationProvider _authenticationProvider = Get.find<AuthenticationProvider>();

  NativeSIPApiProvider _nativeSIPApiProvider = Get.find<NativeSIPApiProvider>();

  ServerConnectionSetting _serverConnectionSetting =
      Get.find<ServerConnectionSetting>();

  @override
  Future<bool> login(String username, String password, String server) async{
    bool loggedInStatus = false;
//      loggedInStatus = await MethodChannel(PACKAGE_NAME).invokeMethod("loginSIP",<String,dynamic>{
    loggedInStatus = await _nativeSIPApiProvider.methodChannel.invokeMethod("loginSIP",<String,dynamic>{
      "username": username,
      "password": password,
      "serverURI": server
      });
      return loggedInStatus;
  }

  @override
  Future<bool> logout() {
    _authenticationProvider.authModelStore.clear();
    _authenticationProvider.authModelStore.putObject(_authenticationProvider.authModelKey, AuthModel());
    Future.value(true);
  }

  String getSIPUri(String username, String serverAddress) {
    return "$username@$serverAddress";
  }
}
