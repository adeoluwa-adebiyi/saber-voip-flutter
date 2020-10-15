import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/widgets.dart';
import 'package:saber/utils/permissions.dart';

import 'contracts/ContactsActorContract.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/extra.dart' as android_extra;
import 'package:intent/typedExtra.dart' as android_typedExtra;
import 'package:intent/action.dart' as android_action;

class ContactsActor implements ContactsActorContract{

  @override
  Future<Iterable<Contact>> getContactsList({String query=""}) async{
    Iterable<Contact> contactsList = await ContactsService.getContacts(query : query, withThumbnails: false);
    return contactsList;
  }

  @override
  Future<void> createNewContact(Contact contact) async{
    await ContactsService.addContact(contact);
  }

}