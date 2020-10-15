import 'package:contacts_service/contacts_service.dart';
import 'package:saber/domain/models/message_model.dart';


class MessageContactDetailModel{
  final Contact contact;
  final MessageModel lastMessage;

  MessageContactDetailModel({this.contact, this.lastMessage});
}