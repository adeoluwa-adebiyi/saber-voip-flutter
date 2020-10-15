import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/constants/colors.dart';
import 'package:saber/viewmodels/callhistory_screen_viewmodel.dart';
import 'package:saber/viewmodels/contacts_screen_viewmodel.dart';
import 'package:saber/viewmodels/favourite_screen_viewmodel.dart';
import 'package:saber/viewmodels/message_screen_viewmodel.dart';
import 'package:saber/views/screens/callfavorites_screen/CallFavoritesScreen.dart';
import 'package:saber/views/screens/callhistoryscreen/CallHistoryScreen.dart';
import 'package:saber/views/screens/contacts_screen/ContactsScreen.dart';
import 'package:saber/views/screens/dialpadscreen/DialpadScreen.dart';
import 'package:saber/views/screens/messages_screen/MessagesScreen.dart';
import 'package:saber/views/screens/settings_screen/SettingsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    RThemeData rThemeData = Get.find();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: rThemeData.whiteScaffoldBackgroundColor,
        appBar: AppBar(
          title: Text("Rioja Red Fijo"),
          actions: <Widget>[
            FlatButton(onPressed: loadSettingsScreen, child: Icon(Icons.settings, color: Colors.white,))
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.star, size: 34,)),
              Tab(icon: Icon(Icons.history, size: 34,)),
              Tab(icon: Icon(Icons.dialpad, size: 34,)),
              Tab(icon: Icon(Icons.person, size: 34,)),
//              Tab(icon: Icon(Icons.mail, size: 34,)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context)=>FavouritesScreenViewModel(),
                child: CallFavoritesScreen()),
            ChangeNotifierProvider(
              create: (context)=>CallHistoryViewModel(),
                child: CallHistoryScreen()),
            DialpadScreen(),
            ChangeNotifierProvider(
              create: (context)=>ContactsScreenViewModel(),
                child: ContactsScreen()),
//            ChangeNotifierProvider(
//              create: (context)=>MessageScreenViewModel(),
//                child: MessagesScreen())
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(),
      );
  }

  void loadSettingsScreen() {
    Get.to(SettingsScreen());
  }
}
