import 'package:hive/hive.dart';
import 'package:saber/domain/models/user_model.dart';

part 'auth_model.g.dart';

@HiveType(typeId: 2)
class AuthModel {
  @HiveField(0)
  UserModel userModel;

  @HiveField(1)
  bool authenticated;

  @HiveField(2)
  String authToken;

  @HiveField(3)
  String serverURI;

  AuthModel({this.userModel, this.authenticated, this.authToken});

  fromJson(Map<String, dynamic> json) {
    return AuthModel(
      authenticated: json["authenticated"],
        authToken: json["authToken"],
        userModel: UserModel(
            username: json["user"]["username"],
            phoneNumber: json["user"]["phoneNumber"],
            serverURI: json["user"]["serverURI"],
            email: json["user"]["email"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "user": userModel.toJson(),
      "serverURI": userModel.serverURI,
      "authenticated": authenticated,
      "authToken": authToken
    };
  }
}
