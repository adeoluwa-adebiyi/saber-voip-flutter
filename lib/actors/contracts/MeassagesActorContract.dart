import 'package:contacts_service/contacts_service.dart';
import 'package:saber/domain/models/message_contact_model.dart';
import 'package:saber/domain/models/message_model.dart';

abstract class MessagesActorContract{
  sendMessage(MessageContactDetailModel messageModel);
  Iterable<MessageModel> receiveMessages();
  Iterable<MessageModel> fetchMessages();
  Iterable<MessageContactDetailModel> fetchMessageContacts();
}