import 'package:saber/domain/models/favourites_detail_model.dart';

abstract class FavouritesActorContract{
  Iterable<FavouritesDetailModel> fetchFavourites();
}