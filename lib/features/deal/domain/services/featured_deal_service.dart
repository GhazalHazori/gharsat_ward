import 'package:gharsat_ward/features/deal/domain/repositories/featured_deal_repository_interface.dart';
import 'package:gharsat_ward/features/deal/domain/services/featured_deal_service_interface.dart';

class FeaturedDealService implements FeaturedDealServiceInterface {
  FeaturedDealRepositoryInterface featuredDealRepositoryInterface;
  FeaturedDealService({required this.featuredDealRepositoryInterface});

  @override
  Future getFeaturedDeal({int? shippingMethod}) async {
    return await featuredDealRepositoryInterface.getFeaturedDeal(shippingMethod: shippingMethod);
  }
}
