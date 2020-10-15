import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saber/actors/UserCallerActor.dart';
import 'package:saber/actors/contracts/UserCallerActorContract.dart';

class DialPadScreenViewModel extends ChangeNotifier{

  String _callerUsername = "";

  UserCallerActor _userCallerActor = Get.find<UserCallerActorContract>();

  get callerUsername => _callerUsername;

  set callerUsername(String username){
    _callerUsername = username;
  }

  Future<bool> callUser() async {
    return await _userCallerActor.makeCall(_callerUsername);
  }


  Future<bool> videoCallUser() async {
    return await _userCallerActor.makeVideoCall(_callerUsername);
  }

}