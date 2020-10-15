import 'package:get/get.dart';
import 'package:saber/actors/contracts/UserCallerActorContract.dart';
import 'package:saber/providers/NativeSIPApiProvider.dart';

class UserCallerActor extends UserCallerActorContract{

  NativeSIPApiProvider _nativeSIPApiProvider = Get.find<NativeSIPApiProvider>();

  @override
  Future<bool> makeCall(String callerUsername) async {
    bool callingStatus = await _nativeSIPApiProvider.methodChannel.invokeMethod("makeSIPCall",<String, dynamic>{
      "callerUsername": callerUsername
    });
    return callingStatus;
  }

  @override
  Future<bool> makeVideoCall(String callerUsername) async {
    bool callingStatus = await _nativeSIPApiProvider.methodChannel.invokeMethod("makeSIPVideoCall",<String, dynamic>{
      "callerUsername": callerUsername
    });
    return callingStatus;
  }

  @override
  Future<bool> endCall() async {
    bool callingStatus = await _nativeSIPApiProvider.methodChannel.invokeMethod("endSIPCall");
    return callingStatus;
  }

}