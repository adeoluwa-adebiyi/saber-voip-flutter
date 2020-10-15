// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CallHistoryModelAdapter extends TypeAdapter<CallHistoryModel> {
  @override
  CallHistoryModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CallHistoryModel()
      ..user = fields[0] as ContactModel
      ..callTimes = fields[1] as int
      ..missedCall = fields[2] as bool
      ..cancelled = fields[3] as bool
      ..missed = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, CallHistoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.user)
      ..writeByte(1)
      ..write(obj.callTimes)
      ..writeByte(2)
      ..write(obj.missedCall)
      ..writeByte(3)
      ..write(obj.cancelled)
      ..writeByte(4)
      ..write(obj.missed);
  }

  @override
  // TODO: implement typeId
  int get typeId => 6;
}
