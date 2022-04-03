import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:pickpointer/packages/session_package/data/models/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/repositories/abstract_session_repository.dart';

class SharedPreferencesFirebaseSessionDatasources
    implements AbstractSessionRepository {
  final String _key = "session";
  final Uuid _uuid = const Uuid();

  CollectionReference? sessions;

  SharedPreferencesFirebaseSessionDatasources(){
    sessions = FirebaseFirestore.instance.collection('c_sessions');
  }

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
    final SessionModel sessionModel = SessionModel(
      isSigned: false,
      idSessions: uuid,
      idUsers: null,
    );
    return sessionModel;
  }

  @override
  Future<AbstractSessionEntity?> getSession() {
    Future<AbstractSessionEntity?> futureAbstractSessionEntity =
        SharedPreferences.getInstance().then((sharedPreferences) {
      String? json = sharedPreferences.getString(_key);
      if (json != null) {
        final SessionModel sessionModel = SessionModel.fromJson(json);
        sessions!.doc(sessionModel.idSessions).get().then((snapshot) {
          final SessionModel sessionModel =
              SessionModel.fromJson(snapshot.data().toString());
        });
        return sessionModel;
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
      SessionModel sessionModel = abstractSessionEntity as SessionModel;
      sharedPreferences.setString(_key, sessionModel.toJson());
      sessions!.doc(sessionModel.idSessions).set(sessionModel.toMap());
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
      SessionModel sessionModel = abstractSessionEntity as SessionModel;
      sharedPreferences.setString(_key, sessionModel.toJson());
      sessions!.doc(sessionModel.idSessions).update(sessionModel.toMap());
      return abstractSessionEntity;
    });
    return futureAbstractSessionEntity;
  }
}
