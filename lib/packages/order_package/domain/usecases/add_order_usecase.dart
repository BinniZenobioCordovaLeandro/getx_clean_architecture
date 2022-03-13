import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/repositories/abstract_order_repository.dart';

class AddOrderUsecase {
  final AbstractOrderRepository _abstractOrderRepository;

  AddOrderUsecase({
    required AbstractOrderRepository? abstractOrderRepository,
  })  : assert(abstractOrderRepository != null),
        _abstractOrderRepository = abstractOrderRepository!;

  Future<void> call({
    required AbstractOrderEntity order,
  }) =>
      _abstractOrderRepository.addOrder(order: order);
}
