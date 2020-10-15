import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/viewmodels/callscreen_viewmodel.dart';

class CallScreen extends StatefulWidget {
  final Contact contact;

  CallScreen({this.contact});

  @override
  State<StatefulWidget> createState() {
    return _CallScreenState();
  }
}

class _CallScreenState extends State<CallScreen> {

  CallScreenViewModel _callScreenViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CallScreenViewModel>(context, listen: false).callUser(widget.contact);
  }

  @override
  Widget build(BuildContext context) {

    _callScreenViewModel = Provider.of<CallScreenViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.redAccent),
                          padding: EdgeInsets.all(40),
                          child: Text(
                            widget.contact.displayName.substring(0, 1),
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                        Text("Calling"),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: Text(
                          widget.contact.phones.first.value.toString(),
                          style: TextStyle(),
                        ))
                      ],
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )
              ],
            )),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      padding: EdgeInsets.all(16.0),
                      onPressed: () {},
                      child: Icon(
                        Icons.mic_off,
                        size: 28,
                      )),
                  FlatButton(
                      padding: EdgeInsets.all(16.0),
                      onPressed: _endCall,
                      child: Icon(
                        Icons.call_end,
                        size: 28,
                      )),
                  FlatButton(
                      padding: EdgeInsets.all(16.0),
                      onPressed: () {},
                      child: Icon(
                        Icons.mic_off,
                        size: 28,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _endCall() async{
    await _callScreenViewModel.endCall();
    Get.back();
  }
}
