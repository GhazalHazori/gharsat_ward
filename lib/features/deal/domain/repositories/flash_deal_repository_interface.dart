import 'package:gharsat_ward/interface/repo_interface.dart';

abstract class FlashDealRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getFlashDeal({int? shippingMethod});
}
