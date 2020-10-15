import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/stores/HiveStore.dart';
import 'package:saber/viewmodels/settings_screen_viewmodel.dart';
import 'package:saber/views/screens/loginscreen/LoginScreen.dart';


class SettingsScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }

}


class _SettingsScreenState extends State<SettingsScreen>{

  @override
  Widget build(BuildContext context) {

    SettingsScreenViewModel settingsScreenViewModel = Provider.of<SettingsScreenViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: <Widget>[
            InkWell(
              onTap: ()=>_attemptResetApplication(settingsScreenViewModel),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(children: <Widget>[
                  Text("Reset Application")
                ],),
              ),
            )
          ],),
        ),
      ),
    );
  }


  void _attemptResetApplication(SettingsScreenViewModel settingsScreenViewModel) async{
    bool appReset = await settingsScreenViewModel.resetApplication();
    print("App Reset: ${appReset}");
    if(appReset){
      Get.off(LoginScreen());
    }
  }
}