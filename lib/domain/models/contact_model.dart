import 'package:hive/hive.dart';

part 'contact_model.g.dart';

@HiveType(typeId: 5)
class ContactModel{

  @HiveField(0)
  String identifier;

  @HiveField(1)
  String displayName;

  @HiveField(2)
  String email;

  @HiveField(3)
  List<String> phones;

  ContactModel({this.identifier, this.phones, this.email, this.displayName});
}