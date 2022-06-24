import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickpointer/packages/route_package/data/models/route_model.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/repositories/abstract_route_repository.dart';

class FirebaseRouteDatasource implements AbstractRouteRepository {
  CollectionReference? routes;
  CollectionReference? routesRequests;

  FirebaseRouteDatasource() {
    routes = FirebaseFirestore.instance.collection('c_routes');
    routesRequests = FirebaseFirestore.instance.collection('c_routes_requests');
  }

  @override
  Future<List<AbstractRouteEntity>>? getRoutes() {
    return routes?.get().then((snapshot) {
      List<AbstractRouteEntity> routes = [];
      for (DocumentSnapshot route in snapshot.docs) {
        routes.add(RouteModel.fromMap(route.data() as Map<String, dynamic>));
      }
      return routes;
    });
  }

  @override
  Future<AbstractRouteEntity>? getRoute({
    required String routeId,
  }) {
    return routes?.doc(routeId).get().then((snapshot) {
      return RouteModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  @override
  Future<AbstractRouteEntity>? setRoute({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    RouteModel routeModel = abstractRouteEntity as RouteModel;
    routes?.doc(routeModel.id).set(routeModel.toMap());
    return Future.value(routeModel);
  }

  @override
  Future<AbstractRouteEntity>? addRoute({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    RouteModel routeModel = abstractRouteEntity as RouteModel;
    routes?.doc(routeModel.id).set(routeModel.toMap());
    return Future.value(routeModel);
  }

  @override
  Future<AbstractRouteEntity>? addRequestRoute({
    required AbstractRouteEntity abstractRouteEntity,
    required String userId,
  }) {
    RouteModel routeModel = abstractRouteEntity as RouteModel;
    Future<AbstractRouteEntity> futureAbstractRouteEntity =
        routesRequests!.add({
      ...routeModel.toMap(),
      'user_id': userId,
    }).then((value) {
      return Future.value(routeModel);
    });
    return futureAbstractRouteEntity;
  }
}
