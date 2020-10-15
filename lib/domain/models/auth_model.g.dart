// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthModelAdapter extends TypeAdapter<AuthModel> {
  @override
  AuthModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthModel(
      userModel: fields[0] as UserModel,
      authenticated: fields[1] as bool,
      authToken: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AuthModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userModel)
      ..writeByte(1)
      ..write(obj.authenticated)
      ..writeByte(2)
      ..write(obj.authToken);
  }

  @override
  // TODO: implement typeId
  int get typeId => 2;
}
