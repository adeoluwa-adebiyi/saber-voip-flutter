import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:saber/actors/contracts/CallHistoryActorContract.dart';
import 'package:saber/domain/models/call_history_model.dart';
import 'package:saber/domain/models/contact_model.dart';
import 'package:saber/domain/models/user_model.dart';
import 'package:saber/providers/NativeSIPApiProvider.dart';
import 'package:saber/stores/HiveStore.dart';

class CallHistoryActor implements CallHistoryActorContract{

//  CallHistoryModelStore _callHistoryModelStore = Get.find<CallHistoryModelStore>();

  NativeSIPApiProvider _nativeSIPApiProvider = Get.find<NativeSIPApiProvider>();

  Future<Iterable<CallHistoryModel>> getCallHistories() async{
    String data = await _nativeSIPApiProvider.methodChannel.invokeMethod("getCallHistory");
    var list = jsonDecode(data);
    List<CallHistoryModel> callList = new List();
    for(var call in list){
      CallHistoryModel callHistoryModel = CallHistoryModel();
      callHistoryModel.callTimes = 1;
      Iterable<Contact> contacts = await ContactsService.getContactsForPhone(call["phone"])??[];
      if(!contacts.isEmpty)
        callHistoryModel.user = ContactModel(identifier: contacts.first.identifier, phones: [call["phone"]],displayName: contacts.first.displayName );

      if(contacts.isEmpty)
        callHistoryModel.user = ContactModel(identifier: null, phones: [call["phone"]],displayName: call["phone"] );
      callHistoryModel
        ..cancelled = call["rejected"]
        ..missedCall = call["missed"]
        ..userMade = call["userMade"]
        ..time = DateTime.fromMillisecondsSinceEpoch(call["timestamp"]);
      callList.add(callHistoryModel);
    }
    return callList;
  }
}