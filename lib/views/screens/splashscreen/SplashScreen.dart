import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saber/actors/AuthenticationActor.dart';
import 'package:saber/actors/contracts/AuthenticationActorContract.dart';
import 'package:saber/constants/colors.dart';
import 'package:saber/providers/AuthenticationProvider.dart';
import 'package:saber/utils/permissions.dart';
import 'package:saber/viewmodels/splashscreen_viewmodel.dart';
import 'package:saber/views/screens/homescreen/HomeScreen.dart';
import 'package:saber/views/screens/loginscreen/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenViewModel _splashScreenViewModel;

  @override
  void initState() {
    super.initState();
    initAction();
  }

  initAction() {
    AuthenticationProvider authenticationProvider =
        Get.find<AuthenticationProvider>();
    _splashScreenViewModel = SplashScreenViewModel(
        authenticationProvider: Get.find<AuthenticationProvider>());

    Timer(Duration(seconds: 2), () {
      _splashScreenViewModel.checkUserLoggedIn();
      if (!_splashScreenViewModel.getAuthenticated()) {
        Get.off(LoginScreen());
      } else {
        PermissionUtil.grantedContactsCameraAndMicroPhonePermission(() async {
          bool signedIn = await Get.find<AuthenticationActorContract>().login(
              _splashScreenViewModel.authenticationProvider
                  .getAuthModel()
                  .userModel
                  .username,
              _splashScreenViewModel.authenticationProvider
                  .getAuthModel()
                  .userModel
                  .password,
            _splashScreenViewModel.authenticationProvider
                .getAuthModel()
                .userModel
                .serverURI,
          );
          if (signedIn) {
            Get.off(HomeScreen());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    RThemeData themeData = Get.find();

    return Scaffold(
        backgroundColor: Color.fromRGBO(135, 24, 24, 1),

    body: Container(
          width: width,
          height: height,
          margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.asset("images/saber_logo.png",width: 200,),
                  ],
                ),
              ),

              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(child: Text("Saber VoIP", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)), margin: EdgeInsets.fromLTRB(0, 0, 0, 16),)

                ],
              ))
            ],
          ),
        ));
  }
}
