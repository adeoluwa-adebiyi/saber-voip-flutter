import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ContactSearchValueProvider with ChangeNotifier{
  String _contactQuery = "";

  String getContactQuery(){
    return _contactQuery;
  }

  void setContactQuery(String query){
    _contactQuery = query;
    notifyListeners();
  }
}