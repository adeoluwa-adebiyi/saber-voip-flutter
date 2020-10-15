import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/constants/LocaleText.dart';
import 'package:saber/constants/colors.dart';
import 'package:saber/domain/models/call_history_model.dart';
import 'package:saber/viewmodels/callhistory_screen_viewmodel.dart';
import 'package:saber/viewmodels/dialpadscreen_viewmodel.dart';
import 'package:saber/views/widgets/CallHistoryItemCard.dart';
import 'package:saber/views/widgets/ContactListItemCard.dart';

class CallHistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CallHistoryScreenState();
  }
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  RThemeData _rThemeData = Get.find<RThemeData>();

  CallHistoryViewModel _callHistoryBloc;

  DialPadScreenViewModel _dialPadScreenViewModel = new DialPadScreenViewModel();


  @override
  Widget build(BuildContext context) {
    _callHistoryBloc = Provider.of<CallHistoryViewModel>(context);
    _callHistoryBloc.getCallHistories();

    LocaleText _localeText = Get.find<LocaleText>();

    return Scaffold(
        backgroundColor: _rThemeData.tabbedScreenBackgroundColor,
        body: _callHistoryBloc.callHistoryList.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            _rThemeData.faintGreyCaptionColor),
                                    child: Icon(
                                      Icons.hourglass_empty,
                                      size: 100,
                                      color: Colors.white,
                                    )),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                    child: Text(
                                      _localeText.noMessagesCaptionText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: _rThemeData
                                              .faintGreyCaptionColor),
                                    ))
                              ],
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                      ],
                    ),
                  ),
                ],
              )
            :ListView.builder(
                  itemCount: _callHistoryBloc.callHistoryList.length,
                  itemBuilder: (context, index) {
                    CallHistoryModel detail =
                        _callHistoryBloc.callHistoryList.elementAt(index);
                    return CallHistoryItemCard(detail, onPressed: ()=>callUser(_callHistoryBloc.callHistoryList.elementAt(index).user.phones.first),);
                  }),
            );
  }

  callUser(String phone){
    _dialPadScreenViewModel.callerUsername = phone;
    _dialPadScreenViewModel.callUser();
  }
}
