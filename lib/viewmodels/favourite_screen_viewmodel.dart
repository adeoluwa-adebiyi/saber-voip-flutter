import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:saber/actors/contracts/FavouritesActorContract.dart';
import 'package:saber/domain/models/favourites_detail_model.dart';

class FavouritesScreenViewModel extends ChangeNotifier{

  Iterable<FavouritesDetailModel> favouriteContactList = [];

  get favouriteList => favouriteContactList;

  FavouritesActorContract _favouritesActorContract = Get.find<FavouritesActorContract>();

  Future<void> fetchFavouritesContacts() async{
    var list =  _favouritesActorContract.fetchFavourites();
    if(list != null) {
      favouriteContactList = list;
//      notifyListeners();
    }
  }
}