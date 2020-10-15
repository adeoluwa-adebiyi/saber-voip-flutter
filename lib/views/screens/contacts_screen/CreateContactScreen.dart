import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saber/actors/ContactsActor.dart';
import 'package:saber/actors/contracts/ContactsActorContract.dart';
import 'package:saber/constants/LocaleText.dart';

class CreateContactScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateContactScreenState();
  }
}

class _CreateContactScreenState extends State<CreateContactScreen> {
  TextEditingController _nameTextEditingController =
      TextEditingController(text: "");
  TextEditingController _phoneNumberTextEditingController =
      TextEditingController(text: "");
  TextEditingController _emailTextEditingController =
      TextEditingController(text: "");
  ContactsActorContract _contactsActorContract =
      Get.find<ContactsActorContract>();

  @override
  Widget build(BuildContext context) {
    LocaleText _localeText = Get.find<LocaleText>();
    return Scaffold(
      appBar: AppBar(
        title: Text(_localeText.createContactAppBarTitle),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameTextEditingController,
              decoration:
                  InputDecoration(hintText: _localeText.contactNameHint),
            ),
            TextFormField(
              controller: _phoneNumberTextEditingController,
              decoration:
                  InputDecoration(hintText: _localeText.contactPhoneNumberHint),
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              controller: _emailTextEditingController,
              decoration:
                  InputDecoration(hintText: _localeText.emailContactHint),
              keyboardType: TextInputType.phone,
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                    child: FlatButton(
                  onPressed: createContact,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Submit",style: TextStyle(color: Colors.white),),
                  ),
                  color: Colors.redAccent,
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void createContact() async {
    Contact contact = Contact(
      givenName: _nameTextEditingController.value.text,
      phones: Iterable.castFrom([
        Item(label: "Main", value: _phoneNumberTextEditingController.value.text)
      ]),
      emails: Iterable.castFrom(
          [Item(label: "Main", value: _emailTextEditingController.value.text)]),
    );
    _contactsActorContract.createNewContact(contact).then((value) {
      Get.snackbar(
          "Contacts", "${contact.displayName} has been successfully added.");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }
}
