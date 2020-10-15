import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:saber/actors/AuthenticationActor.dart';
import 'package:saber/actors/CallHistoryActor.dart';
import 'package:saber/actors/ContactsActor.dart';
import 'package:saber/actors/FavouritesActor.dart';
import 'package:saber/actors/UserCallerActor.dart';
import 'package:saber/actors/contracts/AuthenticationActorContract.dart';
import 'package:saber/actors/contracts/CallHistoryActorContract.dart';
import 'package:saber/actors/contracts/ContactsActorContract.dart';
import 'package:saber/actors/contracts/FavouritesActorContract.dart';
import 'package:saber/actors/contracts/MeassagesActorContract.dart';
import 'package:saber/actors/MessagesActor.dart';
import 'package:saber/actors/contracts/UserCallerActorContract.dart';
import 'package:saber/constants/LocaleText.dart';
import 'package:saber/constants/colors.dart';
import 'package:saber/constants/server_connection_settings.dart';
import 'package:saber/domain/models/auth_model.dart';
import 'package:saber/domain/models/call_history_model.dart';
import 'package:saber/domain/models/contact_model.dart';
import 'package:saber/domain/models/favourites_detail_model.dart';
import 'package:saber/domain/models/message_contact_model.dart';
import 'package:saber/domain/models/message_model.dart';
import 'package:saber/domain/models/user_model.dart';
import 'package:saber/providers/AuthenticationProvider.dart';
import 'package:saber/providers/CallHistoryProvider.dart';
import 'package:saber/providers/ContactSearchValueProvider.dart';
import 'package:saber/providers/FavouritesProvider.dart';
import 'package:saber/providers/MesssagesProvider.dart';
import 'package:saber/providers/NativeSIPApiProvider.dart';
import 'package:saber/stores/HiveStore.dart';
import 'package:saber/stores/Store.dart';
import 'package:uuid/uuid.dart';

void injectAppConstantsModule() {
  Get.put(RThemeData());
}

Future<bool> injectStorageModule() async {
  UserModelStore userModelStore = await UserModelStore().init("USER_STORE", () {
    if (!Hive.isAdapterRegistered(UserModelAdapter().typeId))
      Hive.registerAdapter(UserModelAdapter());
  });

  AuthModelStore authModelStore = await AuthModelStore().init("AUTH_STORE", () {
    if (!Hive.isAdapterRegistered(AuthModelAdapter().typeId))
      Hive.registerAdapter(AuthModelAdapter());
  });

  MessageModelStore messageModelStore =
      await MessageModelStore().init("MESSAGE_STORE", () {
    if (!Hive.isAdapterRegistered(MessageModelAdapter().typeId))
      Hive.registerAdapter(MessageModelAdapter());
  });

  FavoritesDetailModelStore favoritesDetailModelStore =
      await FavoritesDetailModelStore().init("FAVOURITES_STORE", () {
    if (!Hive.isAdapterRegistered(FavouritesDetailModelAdapter().typeId)) {
      Hive.registerAdapter(FavouritesDetailModelAdapter());
      Hive.registerAdapter(ContactModelAdapter());
    }
  });

  CallHistoryModelStore callHistoryModelStore = await CallHistoryModelStore().init();

//  favoritesDetailModelStore.putObject(
//      "FelixTest",
//      FavouritesDetailModel(
//          contactModel: ContactModel(
//              displayName: "Tomasz",
//              phones: ["373535363"],
//              email: "tomasz@mail.com")));

  Get.put<UserModelStore>(userModelStore);
  Get.put<AuthModelStore>(authModelStore);
  Get.put<MessageModelStore>(messageModelStore);
  Get.put<FavoritesDetailModelStore>(favoritesDetailModelStore);
  Get.put<CallHistoryModelStore>(callHistoryModelStore);

  return userModelStore != null && authModelStore != null;
}

void injectServerConnectionSettingsModule() {
  Get.put<ServerConnectionSetting>(ServerConnectionSetting());
}

Future injectProviderModule() async {
  // Inject Auth Provider
  Get.put<AuthenticationProvider>(
      AuthenticationProvider(authModelStore: Get.find<AuthModelStore>()));
//  Get.put<MessagesProvider>(
//      MessagesProvider(messageModelStore: Get.find<MessageModelStore>())
//  );
  Get.put<FavouritesProvider>(FavouritesProvider(
      favoritesDetailModelStore: Get.find<FavoritesDetailModelStore>()));
  Get.put<CallHistoryProvider>(CallHistoryProvider(
      callHistoryModelStore: Get.find<CallHistoryModelStore>()));
//  Get.put<ContactSearchValueProvider>(ContactSearchValueProvider());
}

void injectActorsModule() {
  Get.put<AuthenticationActorContract>(AuthenticationActor());
  Get.put<UserCallerActorContract>(UserCallerActor());
  Get.put<ContactsActorContract>(ContactsActor());
//  Get.put<MessagesActorContract>(MessagesActor());
  Get.put<FavouritesActorContract>(FavouritesActor());
  Get.put<CallHistoryActorContract>(CallHistoryActor());
}

void injectLocaleDataModule() {
  Get.put<LocaleText>(EnglishLocalText());
}

void injectNativeApiModule() {
  Get.put<NativeSIPApiProvider>(NativeSIPApiProvider());
}

Future<bool> injectAppDependencies() async {
  injectNativeApiModule();
  injectAppConstantsModule();
  injectServerConnectionSettingsModule();
  await injectStorageModule();
  await injectProviderModule();
  injectActorsModule();
  injectLocaleDataModule();
  return true;
}
