import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/repositories/abstract_order_repository.dart';

class UpdateOrderUsecase {
  final AbstractOrderRepository _abstractOrderRepository;

  UpdateOrderUsecase({
    required AbstractOrderRepository? abstractOrderRepository,
  })  : assert(abstractOrderRepository != null),
        _abstractOrderRepository = abstractOrderRepository!;

  Future<AbstractOrderEntity>? call({
    required AbstractOrderEntity order,
  }) =>
      _abstractOrderRepository.updateOrder(order: order);
}
