import 'dart:async';

import 'package:pickpointer/packages/route_package/data/models/route_model.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/repositories/abstract_route_repository.dart';

class FirebaseRouteDatasource implements AbstractRouteRepository {
  FirebaseRouteDatasource();

  @override
  Future<List<AbstractRouteEntity>>? getRoutes() {
    return Future.value(<AbstractRouteEntity>[
      const RouteModel(
        id: '1',
        title: 'RutaRapida',
        description:
            'RutaRapida: +20min\nDestino: Óvalo Santa Anita\nOrigen: Huertos De Manchay',
        price: "5.00",
        from:
            "Huertos De Manchay, huertos de manchay, Avenida Victor Malasquez, Pachacamac District",
        startLat: '-12.123276353363956',
        startLng: '-76.87233782753958',
        to: "Óvalo Santa Anita, Ate",
        endLat: '-12.0552257792263',
        endLng: '-76.96429734159008',
      ),
      const RouteModel(
        id: '2',
        title: 'RutaRapida',
        description:
            'RutaRapida: +20min\nDestino: Huertos De Manchay\nOrigen: Sodimac - Ate',
        price: "5.00",
        from: "Av Los Frutales 12-28, Ate 15023",
        startLat: '-12.056521974628302',
        startLng: '-76.96826304806027',
        to: "Huertos De Manchay, huertos de manchay, Avenida Victor Malasquez, Pachacamac District",
        endLat: '-12.12309955704797',
        endLng: '-76.87257722740875',
      ),
    ]);
  }

  @override
  Future<AbstractRouteEntity>? getRoute({
    required String userId,
  }) {
    return null;
  }

  @override
  Future<AbstractRouteEntity>? setRoute({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    return Future.value(abstractRouteEntity);
  }

  @override
  Future<AbstractRouteEntity>? addRoute({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    return Future.value(abstractRouteEntity);
  }

  @override
  Future<AbstractRouteEntity>? addRequestRoute({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    return Future.delayed(
      const Duration(seconds: 3),
      () {
        return abstractRouteEntity;
      },
    );
  }
}
