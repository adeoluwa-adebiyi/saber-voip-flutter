import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saber/views/screens/contacts_screen/ContactInfoDisplay.dart';

class ContactListItemCard extends StatelessWidget {
  final Contact contact;
  bool hidePhone;
  bool hideVideoCam;
  bool hideMessage;
  Function onPressed = (){
  };

  ContactListItemCard(this.contact,{this.hideMessage=false, this.hidePhone=false, this.hideVideoCam=false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          contact.displayName.substring(0, 1) ??
                              "Unknown Contact",
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      ],
                    ),
                    height: 70,
                    width: 70,
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(contact.displayName))
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    hidePhone?Container():Icon(Icons.call),
                    hideVideoCam?Container():Icon(Icons.videocam),
                    hideMessage?Container():Icon(Icons.chat)
                  ],
                ))
          ],
        ),
      ),
    );
  }

//  void showContactInfoPage() {
//    Get.to(ContactInfoDisplay(contact));
//  }
}
