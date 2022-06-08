import 'package:pickpointer/packages/vehicle_package/domain/entities/abstract_vehicle_entity.dart';

abstract class AbstractVehicleRepository {
  Future<List<AbstractVehicleEntity>>? getVehicles();

  Future<AbstractVehicleEntity>? getVehicle({
    required String vehicleId,
  });

  Stream<AbstractVehicleEntity> streamVehicle({
    required String vehicleId,
  });

  Future<AbstractVehicleEntity> addVehicle({
    required AbstractVehicleEntity vehicle,
  });

  Future<AbstractVehicleEntity> updateVehicle({
    required AbstractVehicleEntity vehicle,
  });
}
