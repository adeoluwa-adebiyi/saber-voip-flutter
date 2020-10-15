import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/actors/AuthenticationActor.dart';
import 'package:saber/actors/contracts/AuthenticationActorContract.dart';
import 'package:saber/providers/NativeSIPApiProvider.dart';
import 'package:saber/stores/HiveStore.dart';

class SettingsScreenViewModel extends ChangeNotifier{

  AuthenticationActorContract authenticationActor = Get.find<AuthenticationActorContract>();

  NativeSIPApiProvider _nativeSIPApiProvider = Get.find<NativeSIPApiProvider>();

  Future<bool> resetApplication() async{
    authenticationActor.logout();
    UserModelStore userModelStore = Get.find<UserModelStore>();
    userModelStore.clear();
    MessageModelStore messageModelStore = Provider.of<MessageModelStore>(Get.context, listen: false);
    messageModelStore.clear();
    FavoritesDetailModelStore favoritesDetailModelStore = Get.find<FavoritesDetailModelStore>();
    favoritesDetailModelStore.clear();
    CallHistoryModelStore callHistoryModelStore = Get.find<CallHistoryModelStore>();
    callHistoryModelStore.clear();
    return await _nativeSIPApiProvider.methodChannel.invokeMethod("resetAccount");
  }

}