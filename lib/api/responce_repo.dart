import 'package:task1/model/user_model.dart';

class LoginResponse {
  final String token;
  final bool isSuccess;
  final User? currentUser;

  LoginResponse(this.token, this.isSuccess, this.currentUser);

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'isSuccess': isSuccess,
      'currentUser': currentUser?.toJson(),
    };
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      json['token'] as String,
      json['isSuccess'] as bool,
      json['currentUser'] != null ? User.fromJson(json['currentUser']) : null,
    );
  }
}
