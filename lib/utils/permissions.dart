import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil{

  static grantedContactsCameraAndMicroPhonePermission(Function callback) async{
    if ( ! await Permission.camera.request().isGranted ) {
      // Either the permission was already granted before or the user just granted it.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();
      if(statuses[Permission.camera].isDenied){
        return;
      }

      if(statuses[Permission.camera].isUndetermined){
        print("Undecided camera");
      }


    }

    if ( ! await Permission.microphone.request().isGranted ) {
      // Either the permission was already granted before or the user just granted it.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
      ].request();
      if(statuses[Permission.microphone].isDenied){
        return;
      }

      if(statuses[Permission.microphone].isUndetermined){
        print("Undecided microphone");
      }

    }
    

    if ( ! await Permission.storage.request().isGranted ) {
      // Either the permission was already granted before or the user just granted it.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      if(statuses[Permission.storage].isDenied){
        return;
      }

      if(statuses[Permission.storage].isUndetermined){
        print("Undecided storage");
      }

    }

    if ( ! await Permission.contacts.request().isGranted ) {
      // Either the permission was already granted before or the user just granted it.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.contacts,
      ].request();
      if(statuses[Permission.contacts].isDenied){
        return;
      }

      if(statuses[Permission.contacts].isUndetermined){
        print("Undecided contacts");
      }

    }

    callback();

  }

  static grantedDrawOverlayPermission(Function callback) async{
    if ( ! await Permission.byValue(2323).isGranted ) {
      // Either the permission was already granted before or the user just granted it.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.byValue(2323),
      ].request();

      if(statuses[Permission.byValue(2323)].isDenied){
        return;
      }

      if(statuses[Permission.byValue(2323)].isUndetermined){
        print("Undecided App draw overlay");
      }

      callback();
    }
  }

  static grantedReadWriteExternalStoragePermission(Function callback) async{

    if ( ! await Permission.storage.isGranted ) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      if(statuses[Permission.storage].isDenied){
        return;
      }

      if(statuses[Permission.storage].isUndetermined){
        print("Undecided App Storage");
      }

      callback();
    }

  }

}