import 'package:contacts_service/contacts_service.dart';

abstract class ContactsActorContract{
  getContactsList({String query});
  createNewContact(Contact contact);
}