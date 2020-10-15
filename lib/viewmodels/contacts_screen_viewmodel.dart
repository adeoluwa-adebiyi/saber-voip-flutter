import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saber/actors/contracts/ContactsActorContract.dart';

class ContactsScreenViewModel extends ChangeNotifier{

  ContactsActorContract _contactsActor = Get.find<ContactsActorContract>();

  Iterable<Contact> contactsList = [];

  void retrieveContacts({String contactName=""}) async {
    contactsList = await _contactsActor.getContactsList();
    notifyListeners();
  }

  createContact(Contact contact) async{
    await _contactsActor.createNewContact(contact);
  }

}