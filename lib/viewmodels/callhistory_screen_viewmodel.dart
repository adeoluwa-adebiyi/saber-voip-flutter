import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/actors/CallHistoryActor.dart';
import 'package:saber/actors/contracts/CallHistoryActorContract.dart';
import 'package:saber/domain/models/call_history_model.dart';

class CallHistoryViewModel extends ChangeNotifier{

  CallHistoryActorContract _callHistoryActor = Get.find<CallHistoryActorContract>();

  List<CallHistoryModel> callHistoryList = [];

  Future<List<CallHistoryModel>> getCallHistories() async{
    List<CallHistoryModel> calls = await _callHistoryActor.getCallHistories();
    callHistoryList = calls;
    notifyListeners();
  }

}