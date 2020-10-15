import 'package:get/get.dart';
import 'package:saber/actors/contracts/FavouritesActorContract.dart';
import 'package:saber/domain/models/favourites_detail_model.dart';
import 'package:saber/providers/FavouritesProvider.dart';
import 'package:saber/stores/HiveStore.dart';

class FavouritesActor extends FavouritesActorContract{

  FavoritesDetailModelStore favoritesDetailModelStore = Get.find<FavoritesDetailModelStore>();

  @override
  Iterable<FavouritesDetailModel> fetchFavourites() {
    var all = favoritesDetailModelStore.getAll();
    print("ALL_FAVS: ${all}");
    return all;
  }

}