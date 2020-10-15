import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saber/stores/HiveStore.dart';

class MessagesProvider with ChangeNotifier{
  MessageModelStore messageModelStore = Get.find<MessageModelStore>();
  MessagesProvider({this.messageModelStore});
}