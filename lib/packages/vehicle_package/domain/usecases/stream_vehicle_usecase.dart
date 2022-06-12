import 'package:pickpointer/packages/vehicle_package/domain/entities/abstract_vehicle_entity.dart';
import 'package:pickpointer/packages/vehicle_package/domain/repositories/abstract_vehicle_repository.dart';

class StreamVehicleUsecase {
  final AbstractVehicleRepository _abstractVehicleRepository;

  StreamVehicleUsecase({
    required AbstractVehicleRepository? abstractVehicleRepository,
  })  : assert(abstractVehicleRepository != null),
        _abstractVehicleRepository = abstractVehicleRepository!;

  Stream<AbstractVehicleEntity> call({
    required String vehicleId,
  }) =>
      _abstractVehicleRepository.streamVehicle(vehicleId: vehicleId);
}
