import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/constants/LocaleText.dart';
import 'package:saber/constants/colors.dart';
import 'package:saber/domain/models/message_contact_model.dart';
import 'package:saber/viewmodels/contacts_screen_viewmodel.dart';
import 'package:saber/viewmodels/message_screen_viewmodel.dart';
import 'package:saber/views/widgets/ContactListItemCard.dart';

import 'ContactSelectorScreen.dart';

class MessagesScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MessagesScreenState();
  }

}


class _MessagesScreenState extends State<MessagesScreen>{

  RThemeData _rThemeData = Get.find<RThemeData>();

  MessageScreenViewModel _messageScreenBloc;

  @override
  Widget build(BuildContext context) {

    _messageScreenBloc = Provider.of<MessageScreenViewModel>(context);
    _messageScreenBloc.fetchMessageContacts();
    LocaleText _localeText = Get.find<LocaleText>();

    return Scaffold(
      backgroundColor: _rThemeData.tabbedScreenBackgroundColor,
      body:  _messageScreenBloc.messageList.isEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                _rThemeData.faintGreyCaptionColor),
                            child: Icon(
                              Icons.hourglass_empty,
                              size: 100,
                              color: Colors.white,
                            )),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Text(
                              _localeText.noMessagesCaptionText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: _rThemeData
                                      .faintGreyCaptionColor),
                            ))
                      ],
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )
              ],
            ),
          ),
        ],
      )
          : ListView.builder(
        itemCount: _messageScreenBloc.messageList.length,
          itemBuilder: (context, index){
            MessageContactDetailModel detail = _messageScreenBloc.messageList.elementAt(index);
            return ContactListItemCard(
              detail.contact, onPressed:()=> loadMessageUserScreen(detail.contact),hidePhone: true,hideVideoCam: true,);}),

      floatingActionButton: FloatingActionButton(
        onPressed: proceedSelectUserForMessage,
        child: Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }


  void proceedSelectUserForMessage() {
    Get.to(ChangeNotifierProvider(
      create: (context)=> ContactsScreenViewModel(),
        child: ContactSelectorScreen()));
  }

  loadMessageUserScreen(Contact contact) {
  }
}
