import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/actors/contracts/MeassagesActorContract.dart';
import 'package:saber/domain/models/message_contact_model.dart';
import 'package:saber/domain/models/message_model.dart';
import 'package:saber/providers/NativeSIPApiProvider.dart';
import 'package:saber/stores/HiveStore.dart';


class MessagesActor extends MessagesActorContract with ChangeNotifier{

  MessagesActor(this.messagesModelStore);

  MessageModelStore messagesModelStore;

  NativeSIPApiProvider nativeSIPApiProvider = Get.find<NativeSIPApiProvider>();

  @override
  List<MessageModel> fetchMessages() {
    return null;
  }

  @override
  Iterable<MessageContactDetailModel> fetchMessageContacts() {
    return messagesModelStore.getAllUsers();
  }

  @override
  Iterable<MessageModel> receiveMessages() {
    // TODO: implement receiveMessages
    throw UnimplementedError();
  }

  @override
  Future<bool> sendMessage(MessageContactDetailModel messageModel) async{
    bool sent = await nativeSIPApiProvider.methodChannel.invokeMethod("sendChat",<String, dynamic>{
      "message": messageModel.lastMessage.message,
      "username": messageModel.lastMessage.toUser.phoneNumber
    });

    if(sent) {
      if (messagesModelStore.getObject(messageModel.contact.identifier) == null) {
        messagesModelStore.putObject(messageModel.contact.identifier, [messageModel.lastMessage]);
      }else{
        var list = messagesModelStore.getObject(messageModel.contact.identifier);
        list.add(messageModel.lastMessage);
        messagesModelStore.putObject("${messageModel.contact.identifier}:${messageModel.contact.displayName}", list);
      }
    }
  }

}


//class MockMessagesActor extends MessagesActorContract{
//
//  MessageModelStore _messagesModelStore = Get.find<MessageModelStore>();
//
//  @override
//  List<MessageModel> fetchMessages() {
//    return _messagesModelStore.getAll();
//  }
//
//  @override
//  Iterable<MessageModel> receiveMessages() {
//    // TODO: implement receiveMessages
//    throw UnimplementedError();
//  }
//
//  @override
//  Future<bool> sendMessage(MessageModel messageModel) async{
//    return Future.delayed(Duration(seconds: 10),()=>true);
//  }
//}