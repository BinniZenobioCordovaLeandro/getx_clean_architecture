import 'dart:async';
import 'dart:convert';

import 'package:pickpointer/packages/vehicle_package/data/models/vehicle_model.dart';
import 'package:pickpointer/packages/vehicle_package/domain/entities/abstract_vehicle_entity.dart';
import 'package:pickpointer/packages/vehicle_package/domain/repositories/abstract_vehicle_repository.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseVehicleDatasource implements AbstractVehicleRepository {
  FirebaseDatabase? firebaseDatabase;
  String? table;

  FirebaseVehicleDatasource() {
    firebaseDatabase = FirebaseDatabase.instance;
    table = 'c_vehicles';
  }

  @override
  Future<List<AbstractVehicleEntity>>? getVehicles() {
    return Future.value([]);
  }

  @override
  Future<AbstractVehicleEntity>? getVehicle({
    required String vehicleId,
  }) {
    return Future.value(const VehicleModel());
  }

  @override
  Stream<AbstractVehicleEntity> streamVehicle({
    required String vehicleId,
  }) {
    DatabaseReference databaseReference =
        firebaseDatabase!.ref("$table/$vehicleId");

    StreamController<AbstractVehicleEntity>
        streamControllerAbstractVehicleEntity =
        StreamController<AbstractVehicleEntity>();

    Stream<AbstractVehicleEntity> streamAbstractVehicleEntity =
        streamControllerAbstractVehicleEntity.stream;

    databaseReference.onValue.listen((DatabaseEvent event) {
      Map<String, dynamic> data = jsonDecode(jsonEncode(event.snapshot.value));
      final VehicleModel vehicleModel = VehicleModel.fromMap(data);
      streamControllerAbstractVehicleEntity.sink.add(vehicleModel);
    });

    return streamAbstractVehicleEntity;
  }

  @override
  Future<AbstractVehicleEntity> addVehicle({
    required AbstractVehicleEntity vehicle,
  }) {
    return Future.value(vehicle);
  }

  @override
  Future<AbstractVehicleEntity> updateVehicle({
    required AbstractVehicleEntity vehicle,
  }) {
    DatabaseReference databaseReference =
        firebaseDatabase!.ref("$table/${vehicle.id}");

    VehicleModel vehicleModel = vehicle as VehicleModel;

    databaseReference.update(vehicleModel.toMap());

    return Future.value(vehicle);
  }
}
