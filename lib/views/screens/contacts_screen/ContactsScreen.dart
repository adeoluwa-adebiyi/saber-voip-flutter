import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/constants/colors.dart';
import 'package:saber/providers/ContactSearchValueProvider.dart';
import 'package:saber/viewmodels/contacts_screen_viewmodel.dart';
import 'package:saber/views/widgets/ContactListItemCard.dart';

import 'ContactInfoDisplay.dart';
import 'CreateContactScreen.dart';

class ContactsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactsScreenState();
  }
}

class _ContactsScreenState extends State<ContactsScreen> {
  ContactSearchValueProvider _contactSearchProvider;

  TextEditingController _textEditingController =
      TextEditingController(text: "");

  RThemeData _rThemeData = Get.find<RThemeData>();

  @override
  Widget build(BuildContext context) {
    _contactSearchProvider = Provider.of<ContactSearchValueProvider>(context);
    ContactsScreenViewModel contactsScreenViewModelBloc =
        Provider.of<ContactsScreenViewModel>(context);
    contactsScreenViewModelBloc.retrieveContacts(
        contactName: _contactSearchProvider.getContactQuery());

    return Scaffold(
      backgroundColor: _rThemeData.tabbedScreenBackgroundColor,
      body: Stack(children: <Widget>[
        contactsScreenViewModelBloc.contactsList.isEmpty
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
                itemBuilder: (context, index){
                  var contact = contactsScreenViewModelBloc.contactsList.elementAt(index);
                  return ContactListItemCard(
                    contact,onPressed: ()=>Get.to(ContactInfoDisplay(contact))
                  );}),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Get.to(CreateContactScreen());},
        child: Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _contactSearchProvider.dispose();
  }

}
