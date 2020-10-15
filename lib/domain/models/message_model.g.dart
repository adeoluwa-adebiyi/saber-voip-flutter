// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  MessageModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModel(
      message: fields[2] as String,
      fromUser: fields[0] as UserModel,
      toUser: fields[1] as UserModel,
      time: fields[3] as DateTime,
      draft: fields[5] as bool,
      failed: fields[6] as bool,
      sent: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.fromUser)
      ..writeByte(1)
      ..write(obj.toUser)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.sent)
      ..writeByte(5)
      ..write(obj.draft)
      ..writeByte(6)
      ..write(obj.failed);
  }

  @override
  int get typeId => 3;
}
