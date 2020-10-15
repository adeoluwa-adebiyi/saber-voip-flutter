import 'package:hive/hive.dart';
import 'package:saber/domain/models/user_model.dart';

part "message_model.g.dart";

@HiveType(typeId: 3)
class MessageModel{

  MessageModel({this.message, this.fromUser, this.toUser, this.time, this.draft=true, this.failed=false, this.sent=false});

  @HiveField(0)
  UserModel fromUser;

  @HiveField(1)
  UserModel toUser;

  @HiveField(2)
  String message;

  @HiveField(3)
  DateTime time;

  @HiveField(4)
  bool sent;

  @HiveField(5)
  bool draft;

  @HiveField(6)
  bool failed;

  Map<String, dynamic> toJson(){
    return {
      "fromUser":fromUser.toJson(),
      "toUser":toUser.toJson(),
      "message": message,
      "time": time.millisecondsSinceEpoch,
      "sent":sent,
      "draft":draft,
      "failed":failed
    };
  }

  MessageModel fromJson(Map<String,dynamic> json){
    return MessageModel(
      fromUser: json["fromUser"],
      toUser: json["toUser"],
      message: json["message"],
      time: json["time"],
      sent: json["sent"],
      draft: json["draft"],
      failed: json["failed"]
    );
  }
}