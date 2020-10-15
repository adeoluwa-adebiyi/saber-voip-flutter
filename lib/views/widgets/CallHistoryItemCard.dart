import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:saber/domain/models/call_history_model.dart';
import 'package:saber/views/screens/contacts_screen/ContactInfoDisplay.dart';


class CallHistoryItemCard extends StatelessWidget {
  final CallHistoryModel callHistoryItem;
  bool hidePhone;
  bool hideVideoCam;
  bool hideMessage;
  Function onPressed = (){
  };

  CallHistoryItemCard(this.callHistoryItem,{this.onPressed});

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
                  //Thumbnail
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          callHistoryItem.user.displayName.substring(0, 1),
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      ],
                    ),
                    height: 70,
                    width: 70,
                  ),

                  Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(callHistoryItem.user.displayName, textAlign: TextAlign.start,),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Marquee(
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Icon(Icons.timer, color: Colors.grey,),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                                    child: Text(getTime(callHistoryItem.time), style: TextStyle(fontSize: 10),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(children: <Widget>[
                      Row(children: <Widget>[
                        Column(
                          children: <Widget>[
                            callHistoryItem.missedCall&&!callHistoryItem.userMade?Icon(Icons.call_received, color: Colors.red,):Container(),
                            !callHistoryItem.cancelled?Container():Icon(Icons.call_end, color: Colors.red,),
                            !callHistoryItem.missedCall&&!callHistoryItem.userMade?Icon(Icons.call_received, color:Colors.green,):Container(),
                            callHistoryItem.userMade?Icon(Icons.call_made, color:Colors.grey,):Container(),

                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Column(
                            children: <Widget>[
                              callHistoryItem.missedCall?Text("Missed", style: TextStyle(fontSize: 10),):Container(),
                              !callHistoryItem.cancelled?Container():Text("Cancelled", style: TextStyle(fontSize: 10),),
                              !callHistoryItem.missedCall?Text("Call", style:TextStyle(fontSize: 10),):Container(),

                            ],
                          ),
                        )
                      ],),
                      Row(
                        children: <Widget>[
                        ],
                      )
                    ],)
                  ],
                ))
          ],
        ),
      ),
    );
  }

  String getTime(DateTime datetime){

    if(Jiffy(datetime).dayOfYear == Jiffy().dayOfYear)
      return "Today" +
          ", ${datetime.hour}:${datetime.minute>9?datetime.minute:"0${datetime.minute}"}";

    if(Jiffy(datetime).dayOfYear - Jiffy().dayOfYear == -1)
      return "Yesterday" +
          ", ${datetime.hour}:${datetime.minute>9?datetime.minute:"0${datetime.minute}"}";

    if(Jiffy(datetime).dayOfYear - Jiffy().dayOfYear  < -1)
      return "${DateFormat('EEE, d/M/y ').format(datetime)} ${datetime.hour}:${datetime.minute>9?datetime.minute:"0${datetime.minute}"}";

    return "...";

  }
}