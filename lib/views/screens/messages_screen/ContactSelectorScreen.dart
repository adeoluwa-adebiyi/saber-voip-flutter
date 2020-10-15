import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/constants/colors.dart';
import 'package:saber/viewmodels/contacts_screen_viewmodel.dart';
import 'package:saber/views/widgets/ContactListItemCard.dart';

import 'MessageUserScreen.dart';

class ContactSelectorScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactSelectorScreenState();
  }
}

class _ContactSelectorScreenState extends State<ContactSelectorScreen> {
  @override
  Widget build(BuildContext context) {

    ContactsScreenViewModel contactsScreenViewModelBloc =
        Provider.of<ContactsScreenViewModel>(context);
    contactsScreenViewModelBloc.retrieveContacts(contactName: "");

    RThemeData _rThemeData = Get.find<RThemeData>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Contact"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: contactsScreenViewModelBloc.contactsList.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                      "Empty Contacts.",
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
            physics: const AlwaysScrollableScrollPhysics (),
                itemCount: contactsScreenViewModelBloc.contactsList.length,
                itemBuilder: (context, index) => ContactListItemCard(
                    contactsScreenViewModelBloc.contactsList.elementAt(index),
                    hidePhone: true,
                    hideVideoCam: true,
                    onPressed: () => Get.off(MessageUserScreen(contact:
                        contactsScreenViewModelBloc.contactsList
                            .toList()[index])))),
      ),
    );
  }
}
