import 'package:get/get.dart';
import 'package:saber/stores/HiveStore.dart';

class CallHistoryProvider{

  CallHistoryModelStore callHistoryModelStore = Get.find<CallHistoryModelStore>();

  CallHistoryProvider({this.callHistoryModelStore});

}