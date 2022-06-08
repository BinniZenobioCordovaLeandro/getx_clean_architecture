import 'package:pickpointer/packages/vehicle_package/domain/entities/abstract_vehicle_entity.dart';
import 'package:pickpointer/packages/vehicle_package/domain/repositories/abstract_vehicle_repository.dart';

class GetVehiclesUsecase {
  final AbstractVehicleRepository _abstractVehicleRepository;

  GetVehiclesUsecase({
    required AbstractVehicleRepository? abstractVehicleRepository,
  })  : assert(abstractVehicleRepository != null),
        _abstractVehicleRepository = abstractVehicleRepository!;

  Future<List<AbstractVehicleEntity>>? call() =>
      _abstractVehicleRepository.getVehicles();
}
