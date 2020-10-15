import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/actors/MessagesActor.dart';
import 'package:saber/di/injector.dart';
import 'package:saber/providers/ContactSearchValueProvider.dart';
import 'package:saber/stores/HiveStore.dart';
import 'package:saber/viewmodels/settings_screen_viewmodel.dart';

import 'views/screens/splashscreen/SplashScreen.dart';

void main() {
  runApp(saberApp());
}


class saberApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    var future = injectAppDependencies();

    future.then((value) => print("FUTHRE:${value}"));

    return FutureBuilder(
      future:future,
      initialData: false,
      builder:(context, AsyncSnapshot<bool> appReadySnapshot) {
        if (appReadySnapshot.data != null && appReadySnapshot.data)


          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context)=> ContactSearchValueProvider()),
              ChangeNotifierProvider(create: (context)=> Get.find<MessageModelStore>()),
              ChangeNotifierProvider(create: (context)=> MessagesActor(Get.find<MessageModelStore>())),
              ChangeNotifierProvider(create: (context)=> SettingsScreenViewModel())
            ],
            child: GetMaterialApp(
        title: 'RiojRed',
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.red,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MaterialApp(home: SplashScreen()),
      ),
          );
        return MaterialApp(
          home: Scaffold(
            backgroundColor: Color.fromRGBO(135, 24, 24, 1),
          body: Column(
              children: <Widget>[
//                Container(
//                  width: MediaQuery.of(context).size.width,
//                  height: MediaQuery.of(context).size.height,
//                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
//                  decoration: BoxDecoration(
//                      image: DecorationImage(
//                          image: AssetImage("images/saber_logo.png"))),
//                ),
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(20,20,20,20),
//                  child: CircularProgressIndicator(),
//                ),
              ],
            ),
          ),
        );
        },
    );
  }
}