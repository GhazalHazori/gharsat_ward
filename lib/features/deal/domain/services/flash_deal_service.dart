import 'package:gharsat_ward/features/deal/domain/repositories/flash_deal_repository_interface.dart';
import 'package:gharsat_ward/features/deal/domain/services/flash_deal_service_interface.dart';

class FlashDealService implements FlashDealServiceInterface {
  FlashDealRepositoryInterface flashDealRepositoryInterface;

  FlashDealService({required this.flashDealRepositoryInterface});

  @override
  Future get(String productID, {int? shippingMethod}) async {
    return await flashDealRepositoryInterface.get(productID);
  }

  @override
  Future getFlashDeal({int? shippingMethod}) async {
    return await flashDealRepositoryInterface.getFlashDeal(shippingMethod: shippingMethod);
  }
}
