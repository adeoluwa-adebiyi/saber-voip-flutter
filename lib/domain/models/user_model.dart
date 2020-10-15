import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel{

  @HiveField(0)
  String username;

  @HiveField(1)
  String email;

  @HiveField(2)
  String phoneNumber;

  @HiveField(3)
  String password;

  @HiveField(4)
  String serverURI;

  UserModel({this.username, this.email, this.phoneNumber, this.serverURI, this.password});

  Map<String, dynamic> toJson(){
    return {
      "username": username,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
      "server": serverURI
    };
  }

  UserModel fromJson(Map<String, dynamic> json){
    return UserModel(username: username, email: email, phoneNumber: phoneNumber, password: password);
  }
}