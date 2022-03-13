import 'package:uuid/uuid.dart';
import 'package:pickpointer/packages/session_package/data/models/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/repositories/abstract_session_repository.dart';

class SharedPreferencesSessionDatasources implements AbstractSessionRepository {
  final String _key = "session";
  final Uuid _uuid = const Uuid();

  SharedPreferencesSessionDatasources();

  @override
  Future<AbstractSessionEntity> verifySession() {
    Future<AbstractSessionEntity> futureAbstractSessionEntity =
        getSession().then(
      (session) {
        if (session == null) {
          final AbstractSessionEntity abstractSessionEntity = createSession();
          setSession(abstractSessionEntity: abstractSessionEntity);
          return abstractSessionEntity;
        }
        return session;
      },
    );
    return futureAbstractSessionEntity;
  }

  @override
  AbstractSessionEntity createSession() {
    final String uuid = _uuid.v5(Uuid.NAMESPACE_X500, "session");
    return SessionModel(
      isSigned: false,
      idSessions: uuid,
      idUsers: null,
    );
  }

  @override
  Future<AbstractSessionEntity?> getSession() {
    Future<AbstractSessionEntity?> futureAbstractSessionEntity =
        SharedPreferences.getInstance().then((sharedPreferences) {
      String? json = sharedPreferences.getString(_key);
      if (json != null) {
        return SessionModel.fromJson(json);
      } else {
        return null;
      }
    });
    return futureAbstractSessionEntity;
  }

  @override
  Future<AbstractSessionEntity> setSession({
    required AbstractSessionEntity abstractSessionEntity,
  }) {
    Future<AbstractSessionEntity> futureAbstractSessionEntity =
        SharedPreferences.getInstance().then((sharedPreferences) {
      sharedPreferences.setString(
          _key, (abstractSessionEntity as SessionModel).toJson());
      return abstractSessionEntity;
    });
    return futureAbstractSessionEntity;
  }

  @override
  Future<AbstractSessionEntity> deleteSession() {
    Future<AbstractSessionEntity> futureAbstractSessionEntity =
        SharedPreferences.getInstance().then((sharedPreferences) {
      sharedPreferences.remove(_key);
      final AbstractSessionEntity abstractSessionEntity = createSession();
      setSession(abstractSessionEntity: abstractSessionEntity);
      return abstractSessionEntity;
    });
    return futureAbstractSessionEntity;
  }

  @override
  Future<AbstractSessionEntity> updateSession({
    required AbstractSessionEntity abstractSessionEntity,
  }) {
    Future<AbstractSessionEntity> futureAbstractSessionEntity =
        SharedPreferences.getInstance().then((sharedPreferences) {
      sharedPreferences.setString(
          _key, (abstractSessionEntity as SessionModel).toJson());
      return abstractSessionEntity;
    });
    return futureAbstractSessionEntity;
  }
}
