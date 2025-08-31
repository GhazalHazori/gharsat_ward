import 'package:gharsat_ward/interface/repo_interface.dart';

abstract class FeaturedDealRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getFeaturedDeal({int? shippingMethod});
}
