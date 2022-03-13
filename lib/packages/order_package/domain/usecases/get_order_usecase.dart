import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/repositories/abstract_order_repository.dart';

class GetOrderUsecase {
  final AbstractOrderRepository _abstractOrderRepository;

  GetOrderUsecase({
    required AbstractOrderRepository? abstractOrderRepository,
  })  : assert(abstractOrderRepository != null),
        _abstractOrderRepository = abstractOrderRepository!;

  Future<AbstractOrderEntity>? call({
    required String orderId,
  }) =>
      _abstractOrderRepository.getOrder(orderId: orderId);
}
