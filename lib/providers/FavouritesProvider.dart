import 'package:get/get.dart';
import 'package:saber/domain/models/favourites_detail_model.dart';
import 'package:saber/stores/HiveStore.dart';

class FavouritesProvider{
  FavoritesDetailModelStore favoritesDetailModelStore = Get.find<FavoritesDetailModelStore>();
  FavouritesProvider({this.favoritesDetailModelStore});
}