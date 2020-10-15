import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/viewmodels/callscreen_viewmodel.dart';
import 'package:saber/viewmodels/dialpadscreen_viewmodel.dart';
import 'package:saber/views/screens/contacts_screen/CallScreen.dart';

class DialpadScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DialpadScreenState();
  }
}

class _DialpadScreenState extends State<DialpadScreen> {
  DialPadScreenViewModel _dialPadScreenViewModel;

  @override
  void initState() {
    super.initState();
    _dialPadScreenViewModel = new DialPadScreenViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _dialPadScreenViewModel,
      child: Container(
        color: Colors.black38,
        child: SafeArea(
            child: Consumer<DialPadScreenViewModel>(
          builder: (context, bloc, child) =>
              DiallerWidget(makeCall: (number) async {
            bloc.callerUsername = number;
            print("CALLING: ${bloc.callerUsername}");
            bool callMade = await bloc.callUser();
//            if (callMade) {
//              Get.snackbar("Call Attempt", "Successful");
//            } else {
//              Get.snackbar("Call Attempt", "Failed");
//            }
          },makeVideoCall:(number) async {
                bloc.callerUsername = number;
                await bloc.videoCallUser();
              }),
        )),
      ),
    );
  }
}

class DiallerWidget extends StatelessWidget {
  final TextEditingController _textEditingController =
      new TextEditingController(text: "");

  Function makeCall;

  Function makeVideoCall;

  StreamController<DiallerEvent> _streamController = StreamController();

  StreamSink<DiallerEvent> diallerStreamSink;

  DiallerWidget({@required this.makeCall, this.makeVideoCall}) {
    diallerStreamSink = _streamController.sink;
    _streamController.stream.listen(handleEvent);
  }

  handleEvent(DiallerEvent event) {
    if (event is AddNumberDiallerEvent) {
      _textEditingController.text += event.num;
    }

    if (event is DeleteNumberDiallerEvent) {
      List<String> texts = _textEditingController.text.split("");
      texts.removeLast();
      _textEditingController.text = texts.join();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.fromLTRB(0, 0, 10, 16),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.redAccent,
            constraints: BoxConstraints(minHeight: 40),
            margin: EdgeInsets.fromLTRB(10, 20, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 38,color: Colors.white),
                      readOnly: true,
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    )),
                    FlatButton(
                        onPressed: () =>
                            diallerStreamSink.add(DeleteNumberDiallerEvent()),
                        child: Icon(Icons.remove_circle, color: Colors.white,))
                  ],
                crossAxisAlignment: CrossAxisAlignment.center,),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      child: buildKeyPad(1),
                    ),
                    Expanded(
                      child: buildKeyPad(2),
                    ),
                    Expanded(
                      child: buildKeyPad(3),
                    ),
                  ],),

                Row(children: <Widget>[
                  Expanded(
                    child: buildKeyPad(4),
                  ),
                  Expanded(
                    child: buildKeyPad(5),
                  ),
                  Expanded(
                    child: buildKeyPad(6),
                  ),
                ],),

                Row(children: <Widget>[
                  Expanded(
                    child: buildKeyPad(7),
                  ),
                  Expanded(
                    child: buildKeyPad(8),
                  ),
                  Expanded(
                    child: buildKeyPad(9),
                  ),
                ],),

                Row(children: <Widget>[
                  Expanded(
                    child: buildKeyPad("*"),
                  ),
                  Expanded(
                    child: buildKeyPad(0),
                  ),
                  Expanded(
                    child: buildKeyPad("#"),
                  ),
                ],),

              ],
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                    onPressed: callUser,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: Icon(
                        Icons.call,
                        size: 28,
                        color: Colors.white,
                      ),
                    )),
//                FlatButton(
//                    onPressed: videoCallUser,
//                    child: Container(
//                      padding: EdgeInsets.all(20),
//                      decoration: BoxDecoration(
//                          color: Colors.green, shape: BoxShape.circle),
//                      child: Icon(
//                        Icons.videocam,
//                        size: 28,
//                        color: Colors.white,
//                      ),
//                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  void callUser() async{
    await makeCall(_textEditingController.text);
  }

  buildKeyPad(key){

    var keyMap = <dynamic,String>{
      1:"",
      2:"ABC",
      3:"DEF",
      4:"GHI",
      5:"JKL",
      6:"MNO",
      7:"PQRS",
      8:"TUV",
      9:"WXYZ",
      0:"+",
      "*":"",
      "#":""
    };

    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: FlatButton(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        color: Colors.redAccent,
        onLongPress: (){
          if(key == 0)
            diallerStreamSink.add(AddNumberDiallerEvent("+"));
          },
          onPressed: () => diallerStreamSink
              .add(AddNumberDiallerEvent(key.toString())),
          child: Column(
            children: <Widget>[
              Text(key.toString(),style: TextStyle(fontSize: 50, color: Colors.white),),
              Text(keyMap[key], style: TextStyle(color: Colors.white),)
            ],
          )),
    );
  }

  void videoCallUser() async{
    await makeVideoCall(_textEditingController.text);
  }
}

abstract class DiallerEvent {}

class AddNumberDiallerEvent extends DiallerEvent {
  String num;
  AddNumberDiallerEvent(this.num);
}

class DeleteNumberDiallerEvent extends DiallerEvent {}
