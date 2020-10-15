import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saber/actors/UserCallerActor.dart';
import 'package:saber/actors/contracts/UserCallerActorContract.dart';

class CallScreenViewModel extends ChangeNotifier{
  UserCallerActor _userCallerActor = Get.find<UserCallerActorContract>() as UserCallerActor;

  Future<bool> callUser(Contact contact) async{
    return await _userCallerActor.makeCall(contact.phones.first.value);
  }

  Future<bool> videoCallUser(Contact contact) async{
    return await _userCallerActor.makeCall(contact.phones.first.value);
  }

  endCall(){
    _userCallerActor.endCall();
  }

}