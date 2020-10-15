import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saber/domain/models/auth_model.dart';
import 'package:saber/domain/models/call_history_model.dart';
import 'package:saber/domain/models/favourites_detail_model.dart';
import 'package:saber/domain/models/message_contact_model.dart';
import 'package:saber/domain/models/message_model.dart';
import 'package:saber/domain/models/user_model.dart';
import 'package:saber/stores/SQLiteStore.dart';

import 'Store.dart';

class HiveStore<T> extends ChangeNotifier implements Store {
  static HiveStore INSTANCE;
  Box<T> _box;

  // Method for accessing Singleton Hive Store
  // Initiates Hive one-time and generates global userBox
  init(String boxPath, Function onInit) async {
    var dir = await getApplicationDocumentsDirectory();
    if (dir != null) {
      print("DIR path: ${dir.path}/saber**/$boxPath");
      Hive..init(dir.path);
      onInit();
      _box = await Hive.openBox(boxPath);
      return this;
    }
    return INSTANCE;
  }

  // Clears Hive store and deletes from disk
  clear() {
    for (var key in _box.keys) _box.delete(key);
    notifyListeners();
  }

  // Set object in hive store
  putObject(dynamic key, dynamic value) {
    _box.put(key, value);
    notifyListeners();
  }

  // Put object in hive store
  getObject(dynamic key) {
    return _box.get(key);
  }

  // Remove object in hive store
  removeObject(dynamic key) {
    _box.delete(key);
    notifyListeners();
  }

  // Get all objects from store
  getAll() {
    List<T> list = List();
    _box.toMap().forEach((key, value) {
      list.add(value);
    });

    return list;
  }
}

class UserModelStore extends HiveStore<UserModel> {}

class AuthModelStore extends HiveStore<AuthModel> {}

class MessageModelStore extends HiveStore<List<MessageModel>> {
  List<MessageContactDetailModel> getAllUsers() {
    List<MessageContactDetailModel> list = List();
    var keys = _box.keys;
    for (var key in keys) {
      var messageModel = _box.get(key);
      list.add(MessageContactDetailModel(
          contact: Contact(
            phones: <Item>[Item(value:"${messageModel.last.fromUser.phoneNumber}:${messageModel.last.toUser.phoneNumber}")],
              displayName: key.split(":")[1]),
          lastMessage: _box.get(key).last));
    }
    return list;
  }
}

class FavoritesDetailModelStore extends HiveStore<FavouritesDetailModel> {}


class CallHistoryModelStore extends SQLiteStore {

  Future<List<CallHistoryModel>> getCallHistory() async {
    List<CallHistoryModel> callHistoryList = new List();
    print("TABLE: ${SQLiteStore.db}");
    List<Map<String, dynamic>> dataList = await SQLiteStore.db.query(".table",);
    print("KEYS: ${dataList}");
    return [];
  }

  void clear() async{
    await SQLiteStore.db.rawQuery("DELETE FROM call_table;");
  }

}
