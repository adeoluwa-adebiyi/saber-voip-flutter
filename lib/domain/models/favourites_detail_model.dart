import 'package:contacts_service/contacts_service.dart';
import 'package:hive/hive.dart';

import 'contact_model.dart';

part 'favourites_detail_model.g.dart';

@HiveType(typeId: 4)
class FavouritesDetailModel{

  @HiveField(3)
  ContactModel contactModel;

  @HiveField(1)
  String tag;

  @HiveField(2)
  FavouritesDetailModel({this.contactModel, this.tag});
}