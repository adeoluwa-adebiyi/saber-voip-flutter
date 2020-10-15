import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/actors/contracts/AuthenticationActorContract.dart';
import 'package:saber/constants/LocaleText.dart';
import 'package:saber/constants/colors.dart';
import 'package:saber/providers/AuthenticationProvider.dart';
import 'package:saber/utils/permissions.dart';
import 'package:saber/viewmodels/loginscreen_viewmodel.dart';
import 'package:saber/views/screens/homescreen/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController usernameController = TextEditingController(text: "");

  TextEditingController passwordController = TextEditingController(text: "");

  TextEditingController serverURIController = TextEditingController(text: "");

  LoginScreenViewModel _loginScreenViewModel = LoginScreenViewModel(
      authenticationProvider: Get.find<AuthenticationProvider>(),
      authenticationActor: Get.find<AuthenticationActorContract>());

  GlobalKey formKey = GlobalKey<FormState>();

  @override
  void initState() {

    super.initState();

    usernameController.addListener(() {
      _loginScreenViewModel.username = usernameController.value.text;
      debugPrint("LOGINVM USERNAME: ${_loginScreenViewModel.username}");
    });

    passwordController.addListener(() {
      _loginScreenViewModel.password = passwordController.value.text;
      debugPrint("LOGINVM PASSWORD: ${_loginScreenViewModel.password}");
    });

    serverURIController.addListener(() {
      _loginScreenViewModel.serverURI = serverURIController.value.text;
      debugPrint("LOGINVM SERVER: ${_loginScreenViewModel.serverURI}");
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(135, 24, 24, 1),
        body: ChangeNotifierProvider<LoginScreenViewModel>(
      create: (context) => _loginScreenViewModel,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 150,
                              child: Image.asset("images/saber_logo.png", width: 120,)
                              ,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("Proceed with your",textAlign: TextAlign.start,style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400,color: Colors.white),),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("Login", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color:Colors.white),),
                            ],
                          ),
                        ],
                      ),
                    ),


                    LoginScreenFormWidget(
                      usernameController: usernameController,
                      passwordController: passwordController,
                      serverURIController: serverURIController,
                      onSubmit: _onSubmitLogin,
                      formKey: formKey,
                    ),
                    Consumer<LoginScreenViewModel>(
                        builder: (context, bloc, child) {
                          if(bloc.loginWorking)
                            return CircularProgressIndicator();
                          return Container();
                    })
                  ],
                ),
              ),
            )),
      ),
    ));
  }

  _onSubmitLogin() async{
    bool loggedIn = await _loginScreenViewModel.login();
    if(loggedIn){
      PermissionUtil.grantedContactsCameraAndMicroPhonePermission((){

        Get.off(HomeScreen());

      });
    }
  }
}


class LoginScreenFormWidget extends StatelessWidget {

  final TextEditingController usernameController;

  final TextEditingController passwordController;

  final TextEditingController serverURIController;

  final LocaleText _localeText = Get.find<LocaleText>();

  final Function onSubmit;

  final GlobalKey<FormState> formKey;

  RThemeData _rthemeData = Get.find<RThemeData>();

  LoginScreenFormWidget(
      {
        @required this.usernameController,
        @required this.passwordController,
        @required this.serverURIController,
        @required this.onSubmit,
        @required this.formKey
      });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.fromLTRB(16,30,16,16),
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[

            Container(
              decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              padding: EdgeInsets.all(8),
              child: TextFormField(
                validator: validateUsername,
                decoration: InputDecoration(hintText: _localeText.usernameHintText, labelText: "Username",),
                initialValue: usernameController.value.text,
                onChanged: (text) {
                  usernameController.text = text;
                },
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextFormField(
                obscureText: true,
                validator: validatePassword,
                decoration: InputDecoration(hintText: "", labelText: "Password"),
                initialValue: usernameController.value.text,
                onChanged: (text) {
                  passwordController.text = text;
                },
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextFormField(
                decoration: InputDecoration(hintText: _localeText.sipServerHintText, labelText: "SIP server"),
                initialValue: serverURIController.value.text,
                onChanged: (text) {
                  serverURIController.text = text;
                },
              ),
            ),

            Container(

              margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          textColor: Colors.white,
                          color: _rthemeData.loginBtnColor,
                          onPressed: (){
                            if(formKey.currentState.validate())
                              onSubmit();
                          },
                          child: Text(_localeText.signBtnInText))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String validateUsername(String value) {
    if(!RegExp("[0-9]+").hasMatch(value))
      return _localeText.invalidUsernameError;
    return null;
  }

  String validatePassword(String value) {
    if(!RegExp("[a-z0-9\$\#\@]+").hasMatch(value))
      return _localeText.invalidPasswordError;
    return null;
  }
}
