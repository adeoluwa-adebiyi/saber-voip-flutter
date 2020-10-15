import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/actors/MessagesActor.dart';
import 'package:saber/actors/contracts/MeassagesActorContract.dart';
import 'package:saber/domain/models/message_contact_model.dart';

class MessageScreenViewModel extends ChangeNotifier{

  Iterable<MessageContactDetailModel> _messageContactList = [];

  get messageList => _messageContactList;

  MessagesActorContract _messagesActorContract = Provider.of<MessagesActor>(Get.context);

  Future<void> fetchMessageContacts() async{
    var list =  _messagesActorContract.fetchMessageContacts();
    if(list != null) {
      _messageContactList = list;
//      notifyListeners();
    }
  }
}