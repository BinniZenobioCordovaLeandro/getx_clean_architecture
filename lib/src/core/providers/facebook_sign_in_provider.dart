import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

class FacebookUserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? lastName;
  final String? firstName;
  final Picture? picture;

  const FacebookUserModel({
    this.id,
    this.name,
    this.email,
    this.lastName,
    this.firstName,
    this.picture,
  });

  factory FacebookUserModel.fromJson(Map<String, dynamic> json) {
    return FacebookUserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      lastName: json['last_name'] as String?,
      firstName: json['first_name'] as String?,
      picture: json['picture'] == null
          ? null
          : Picture.fromJson(json['picture'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'last_name': lastName,
      'first_name': firstName,
      'picture': picture?.toJson(),
    };
  }

  FacebookUserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? lastName,
    String? firstName,
    Picture? picture,
  }) {
    return FacebookUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      picture: picture ?? this.picture,
    );
  }

  bool? get stringify => true;

  List<Object> get props {
    return [
      id!,
      name!,
      email!,
      lastName!,
      firstName!,
      picture!,
    ];
  }
}

class Picture {
  final Data? data;

  const Picture({
    this.data,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }

  Picture copyWith({
    Data? data,
  }) {
    return Picture(
      data: data ?? this.data,
    );
  }

  bool? get stringify => true;

  List<Object> get props => [
        data!,
      ];
}

class Data {
  final String? url;

  const Data({this.url});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }

  Data copyWith({
    String? url,
  }) {
    return Data(
      url: url ?? this.url,
    );
  }

  bool? get stringify => true;

  List<Object> get props => [
        url!,
      ];
}

class FacebookSignInProvider {
  static final FacebookAuth facebookAuth = FacebookAuth.instance;

  List<String> scopes = ['email'];

  final _domain = 'graph.facebook.com'; // don't use https prefix
  final _version = 'v10.0';

  FacebookSignInProvider({
    List<String>? scopes,
  }) {
    if (scopes != null && scopes.isNotEmpty) scopes = scopes;
  }

  Future<FacebookUserModel?> handleSignIn() async {
    LoginResult loginResult = await facebookAuth.login(
      permissions: scopes,
    );
    if (loginResult.status == LoginStatus.success) {
      final FacebookUserModel? facebookUserModel = await getUser(
        token: loginResult.accessToken?.token,
      );
      return facebookUserModel;
    }
    return null;
  }

  Future<http.Response> getWithoutCredentials(String path,
      {Map<String, String>? queryStringParams}) async {
    final url = Uri.https(_domain, '$_version/$path', queryStringParams);
    dynamic response = await http.get(url);
    return response;
  }

  Future<FacebookUserModel?>? getUser({
    @required String? token,
  }) async {
    final Map<String, String> params = {
      'access_token': token!,
      'fields': 'id,name,email,last_name,first_name,picture{url}',
    };
    final Future<FacebookUserModel?> futureFacebookUserModel =
        getWithoutCredentials('me', queryStringParams: params)
            .then((dynamic response) {
      final decodeData = json.decode(response.body);
      if (decodeData != null && decodeData['email'] != null) {
        FacebookUserModel facebookUserModel =
            FacebookUserModel.fromJson(decodeData);
        return facebookUserModel;
      }
      return null;
    });
    return futureFacebookUserModel;
  }
}
