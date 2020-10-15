import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/actors/MessagesActor.dart';
import 'package:saber/constants/colors.dart';
import 'package:saber/domain/models/message_contact_model.dart';
import 'package:saber/domain/models/message_model.dart';
import 'package:saber/domain/models/user_model.dart';
import 'package:saber/providers/AuthenticationProvider.dart';
import 'package:saber/providers/MesssagesProvider.dart';
import 'package:saber/stores/HiveStore.dart';

class MessageUserScreen extends StatefulWidget {
  final Contact contact;

  MessageUserScreen({@required this.contact});

  @override
  State<StatefulWidget> createState() {
    return _MessageUserScreenState();
  }
}

class _MessageUserScreenState extends State<MessageUserScreen> {
  UserModel authUser =
      Get.find<AuthenticationProvider>().getAuthModel().userModel;

  TextEditingController _messageEntryTextEditingController =
      TextEditingController(text: "");

  MessagesActor messagesActor;

  @override
  Widget build(BuildContext context) {
    messagesActor = Provider.of<MessagesActor>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Consumer<MessageModelStore>(
          builder:(context, messagesModelStore, child) =>Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                      itemCount: messagesModelStore
                              .getObject(widget.contact.identifier)
                              ?.length ??
                          0,
                      itemBuilder: (context, index) {
                        MessageModel messageModel = messagesModelStore
                            .getObject(widget.contact.identifier)[index];
                        return ChatMessageCard(
                          message: MessageModel(
                              message: messageModel.message,
                              fromUser: messageModel.fromUser),
                          authUser: authUser,
                        );
                      })),
              Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.grey[300],
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                        controller: _messageEntryTextEditingController,
                      )),
                      FlatButton(
                          color: Colors.redAccent,
                          onPressed: _sendUserMessage,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _sendUserMessage() async {
    String text = _messageEntryTextEditingController.value.text;
    if (text == "" || text == null) {
      return;
    }
    MessageModel messageModel = MessageModel(
      message: text,
      fromUser: UserModel(
          username: authUser.username,
          phoneNumber: authUser.phoneNumber),
      toUser: UserModel(
          username: widget.contact.displayName,
          phoneNumber: widget.contact.phones.first.value),);
    MessageContactDetailModel messageContactDetailModel = MessageContactDetailModel(contact: widget.contact, lastMessage: messageModel);
    await messagesActor.sendMessage(messageContactDetailModel);
  }
}

class ChatMessageCard extends StatelessWidget {
  final MessageModel message;

  final UserModel authUser;

  ChatMessageCard({@required this.message, @required this.authUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Row(
        mainAxisAlignment: authUser.phoneNumber == message.fromUser.phoneNumber
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: message.fromUser == authUser
                    ? Colors.red[600]
                    : Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.all(16.0),
            child: Text(
              message.message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
