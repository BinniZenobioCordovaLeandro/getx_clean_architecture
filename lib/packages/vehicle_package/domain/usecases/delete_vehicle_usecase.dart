import 'package:pickpointer/packages/vehicle_package/domain/repositories/abstract_vehicle_repository.dart';

class DeleteVehicleUsecase {
  final AbstractVehicleRepository _abstractVehicleRepository;

  DeleteVehicleUsecase({
    required AbstractVehicleRepository? abstractVehicleRepository,
  })  : assert(abstractVehicleRepository != null),
        _abstractVehicleRepository = abstractVehicleRepository!;

  Future<bool> call({
    required String vehicleId,
  }) =>
      _abstractVehicleRepository.deleteVehicle(vehicleId: vehicleId);
}
