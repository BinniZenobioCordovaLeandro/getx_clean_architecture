import 'package:pickpointer/packages/vehicle_package/domain/entities/abstract_vehicle_entity.dart';
import 'package:pickpointer/packages/vehicle_package/domain/repositories/abstract_vehicle_repository.dart';

class UpdateVehicleUsecase {
  final AbstractVehicleRepository _abstractVehicleRepository;

  UpdateVehicleUsecase({
    required AbstractVehicleRepository? abstractVehicleRepository,
  })  : assert(abstractVehicleRepository != null),
        _abstractVehicleRepository = abstractVehicleRepository!;

  Future<AbstractVehicleEntity> call({
    required AbstractVehicleEntity vehicle,
  }) =>
      _abstractVehicleRepository.updateVehicle(vehicle: vehicle);
}
