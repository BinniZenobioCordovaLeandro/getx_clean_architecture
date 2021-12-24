import 'dart:convert';
import 'dart:io';

import 'package:pickpointer/packages/user_package/data/models/user_model.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/repositories/abstract_user_repository.dart';

class HttpUserDatasource implements AbstractUserRepository {
  final HttpClient _httpClient;

  HttpUserDatasource({
    required HttpClient httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<List<AbstractUserEntity>>? getUsers() {
    Future<List<AbstractUserEntity>>? futureListAbstractUserEntity = _httpClient
        .getUrl(Uri.parse('http://jsonplaceholder.typicode.com/users'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      return response.transform(utf8.decoder).join();
    }).then((String string) {
      return json
          .decode(string)
          .map<AbstractUserEntity>((json) => UserModel.fromMap(json))
          .toList() as List<AbstractUserEntity>;
    });
    return futureListAbstractUserEntity;
  }

  @override
  Future<List<AbstractUserEntity>>? getUsersByName({
    required String userName,
  }) {
    Future<List<AbstractUserEntity>>? futureListAbstractUserEntity = _httpClient
        .getUrl(Uri.parse('http://jsonplaceholder.typicode.com/users'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      return response.transform(utf8.decoder).join();
    }).then((String string) {
      return json.decode(string).map<AbstractUserEntity>((json) {
        AbstractUserEntity abstractUserEntity = UserModel.fromMap(json);
        RegExp regExp = RegExp(userName);
        if (regExp.hasMatch('${abstractUserEntity.name}') == true)
          return AbstractUserEntity;
        return null;
      }).toList() as List<AbstractUserEntity>;
    });

    return futureListAbstractUserEntity;
  }

  @override
  Future<AbstractUserEntity>? getUser({
    required int userId,
  }) {
    Future<AbstractUserEntity>? futureAbstractUserEntity = _httpClient
        .getUrl(Uri.parse(
            'https://jsonplaceholder.typicode.com/users?userId=$userId'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      AbstractUserEntity abstractUserEntity = UserModel(id: '$userId');
      return abstractUserEntity;
    });
    return futureAbstractUserEntity;
  }
}
