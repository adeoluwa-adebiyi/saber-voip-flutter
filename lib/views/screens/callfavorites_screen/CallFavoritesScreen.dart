import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saber/constants/LocaleText.dart';
import 'package:saber/constants/colors.dart';
import 'package:saber/domain/models/contact_model.dart';
import 'package:saber/domain/models/favourites_detail_model.dart';
import 'package:saber/viewmodels/favourite_screen_viewmodel.dart';
import 'package:saber/views/screens/contacts_screen/ContactInfoDisplay.dart';
import 'package:saber/views/widgets/ContactListItemCard.dart';

class CallFavoritesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CallFavoritesScreenState();
  }
}

class _CallFavoritesScreenState extends State<CallFavoritesScreen> {
  RThemeData _rThemeData = Get.find<RThemeData>();
  LocaleText _localeText = Get.find<LocaleText>();

  @override
  Widget build(BuildContext context) {
    FavouritesScreenViewModel favouritesScreenBloc =
        Provider.of<FavouritesScreenViewModel>(context);
    favouritesScreenBloc.fetchFavouritesContacts();
    return Scaffold(
      backgroundColor: _rThemeData.tabbedScreenBackgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: favouritesScreenBloc.favouriteContactList.isEmpty
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
                                      _localeText.noFavouritesCaptionText,
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
            : ListView.builder(
                itemCount: favouritesScreenBloc.favouriteContactList.length,
                itemBuilder: (context, index) {
                  FavouritesDetailModel detail = favouritesScreenBloc
                      .favouriteContactList
                      .elementAt(index);
                  return ContactListItemCard(
                    Contact(
                        displayName: detail.contactModel.displayName,
                        emails: <Item>[
                          Item(value: detail.contactModel.email)
                        ],
                        phones: <Item>[
                          for (var phone in detail.contactModel.phones)
                            Item(value: phone)
                        ]),
                    onPressed: () =>
                        loadFavouriteUserScreen(detail.contactModel),
                    hidePhone: true,
                    hideVideoCam: true,
                    hideMessage: true,
                  );
                }),
      ),
    );
  }

  loadFavouriteUserScreen(ContactModel contact) {
    Get.to(ContactInfoDisplay(                    Contact(
        displayName: contact.displayName,
        emails: <Item>[
          Item(value: contact.email)
        ],
        phones: <Item>[
          for (var phone in contact.phones)
            Item(value: phone)
        ])));
  }
}
