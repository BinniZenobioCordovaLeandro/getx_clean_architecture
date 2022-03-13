import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/repositories/abstract_order_repository.dart';

class GetOrdersUsecase {
  final AbstractOrderRepository _abstractOrderRepository;

  GetOrdersUsecase({
    required AbstractOrderRepository? abstractOrderRepository,
  })  : assert(abstractOrderRepository != null),
        _abstractOrderRepository = abstractOrderRepository!;

  Future<List<AbstractOrderEntity>>? call() =>
      _abstractOrderRepository.getOrders();
}
