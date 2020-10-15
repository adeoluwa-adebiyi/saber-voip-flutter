import 'package:hive/hive.dart';
import 'package:saber/domain/models/contact_model.dart';

part 'call_history_model.g.dart';

@HiveType(typeId: 6)
class CallHistoryModel{

  @HiveField(0)
  ContactModel user;

  @HiveField(1)
  int callTimes;

  @HiveField(2)
  bool missedCall;

  @HiveField(3)
  bool cancelled;

  @HiveField(4)
  bool missed;

  DateTime time;

  bool userMade;

}