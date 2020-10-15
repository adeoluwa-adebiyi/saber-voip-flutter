// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourites_detail_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouritesDetailModelAdapter extends TypeAdapter<FavouritesDetailModel> {
  @override
  FavouritesDetailModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouritesDetailModel(
      contactModel: fields[3] as ContactModel,
      tag: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavouritesDetailModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(3)
      ..write(obj.contactModel)
      ..writeByte(1)
      ..write(obj.tag);
  }

  @override
  // TODO: implement typeId
  int get typeId => 4;
}
