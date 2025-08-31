import 'package:gharsat_ward/features/banner/domain/repositories/banner_repository_interface.dart';
import 'package:gharsat_ward/features/banner/domain/services/banner_service_interface.dart';

class BannerService implements BannerServiceInterface {
  BannerRepositoryInterface bannerRepositoryInterface;
  BannerService({required this.bannerRepositoryInterface});

  @override
  Future getList() {
    return bannerRepositoryInterface.getList();
  }
}
