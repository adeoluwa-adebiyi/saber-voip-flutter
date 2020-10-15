import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saber/viewmodels/dialpadscreen_viewmodel.dart';

class ContactInfoDisplay extends StatefulWidget {
  final Contact contact;

  ContactInfoDisplay(this.contact);

  @override
  State<StatefulWidget> createState() {
    return _ContactInfoDisplayState();
  }
}

class _ContactInfoDisplayState extends State<ContactInfoDisplay> {

  DialPadScreenViewModel _dialPadScreenViewModel = new DialPadScreenViewModel();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.redAccent),
                    child: Text(
                      widget.contact.displayName.substring(0, 1),
                      style: TextStyle(fontSize: 100,color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  widget.contact.displayName,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Container(
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey), bottom: BorderSide(color: Colors.grey))),
              margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
              padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                InkWell(onTap:()=>makeCall(widget.contact.phones.first.value),child: Icon(Icons.phone,size: 30,)),
                InkWell(onTap:(){},child: Icon(Icons.videocam,size: 30,)),
                InkWell(onTap:(){},child: Icon(Icons.chat,size: 30,)),

                ],),
            ),
            for(var phone in widget.contact.phones)
            InkWell(
              onTap: ()=>makeCall(phone.value),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(children: <Widget>[
                  Text(phone.value)
                ],),
              ),
            )
          ],
        ),
      ),
    );
  }

  void callPhone() {

  }

  makeCall(String phone) {
    _dialPadScreenViewModel.callerUsername = phone;
    _dialPadScreenViewModel.callUser();
  }
}
