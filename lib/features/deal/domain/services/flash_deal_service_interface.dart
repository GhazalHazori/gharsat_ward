
abstract class FlashDealServiceInterface {

  Future<dynamic> getFlashDeal({int? shippingMethod});
  Future<dynamic> get(String productID, {int? shippingMethod});

}