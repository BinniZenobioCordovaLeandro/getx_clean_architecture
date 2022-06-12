import 'package:pickpointer/packages/vehicle_package/domain/entities/abstract_vehicle_entity.dart';
import 'package:pickpointer/packages/vehicle_package/domain/repositories/abstract_vehicle_repository.dart';

class GetVehicleUsecase {
  final AbstractVehicleRepository _abstractVehicleRepository;

  GetVehicleUsecase({
    required AbstractVehicleRepository? abstractVehicleRepository,
  })  : assert(abstractVehicleRepository != null),
        _abstractVehicleRepository = abstractVehicleRepository!;

  Future<AbstractVehicleEntity>? call({
    required String vehicleId,
  }) =>
      _abstractVehicleRepository.getVehicle(vehicleId: vehicleId);
}
