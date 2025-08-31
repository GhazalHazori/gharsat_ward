import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/paginated_list_view_widget.dart';
import 'package:gharsat_ward/features/deal/controllers/featured_deal_controller.dart';
import 'package:gharsat_ward/features/deal/controllers/flash_deal_controller.dart';
import 'package:gharsat_ward/features/product/controllers/product_controller.dart';
import 'package:gharsat_ward/features/profile/controllers/profile_contrroller.dart';
import 'package:gharsat_ward/helper/responsive_helper.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/utill/images.dart';
import 'package:gharsat_ward/common/basewidget/custom_app_bar_widget.dart';
import 'package:gharsat_ward/common/basewidget/no_internet_screen_widget.dart';
import 'package:gharsat_ward/common/basewidget/product_shimmer_widget.dart';
import 'package:gharsat_ward/common/basewidget/product_widget.dart';
import 'package:provider/provider.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';

class BrandAndCategoryProductShippin extends StatefulWidget {
  final bool isBrand;
  final int? id;
  final String? name;
  final String? image;

  const BrandAndCategoryProductShippin({
    super.key,
    required this.isBrand,
    required this.id,
    required this.name,
    this.image,
  });

  @override
  State<BrandAndCategoryProductShippin> createState() =>
      _BrandAndCategoryProductShippinState();
}

class _BrandAndCategoryProductShippinState
    extends State<BrandAndCategoryProductShippin> {
  final ScrollController _scrollController = ScrollController();
  int selectedTab = 0; // 0 = Express, 1 = Pre-order

  @override
  void initState() {
    _changeTab(0);
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts({int? offset}) async {
    await Provider.of<ProductController>(context, listen: false)
        .initBrandOrCategoryProductList(
      isBrand: widget.isBrand,
      id: widget.id,
      offset: offset ?? 1,
      isUpdate: offset != null,
    );
  }

  void _changeTab(int index) {
    setState(() => selectedTab = index);

    int method = index == 0 ? 1 : 2;

    // غيّر الشحن في كل الكنترولات
    Provider.of<ProductController>(context, listen: false)
        .changeShippingMethod(method);
    Provider.of<FlashDealController>(context, listen: false)
        .changeShippingMethod(method);
    Provider.of<FeaturedDealController>(context, listen: false)
        .changeShippingMethod(method);

    // رجّع المنتجات من الأول
    _loadProducts(offset: 1);
  }

  @override
  Widget build(BuildContext context) {
    final profileCtrl = Provider.of<ProfileController>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(title: widget.name),
      body: Column(
        children: [
          /// ✅ التابات فوق
          Visibility(
            visible: profileCtrl.userInfoModel?.cityId != "1",
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 218, 164),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _changeTab(0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedTab == 0
                                ? const Color.fromARGB(255, 210, 139, 33)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              getTranslated('Express', context) ?? 'Express',
                              style: textMedium.copyWith(
                                color: selectedTab == 0
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => _changeTab(1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedTab == 1
                                ? const Color.fromARGB(255, 210, 139, 33)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              getTranslated('pre Order', context) ??
                                  'Pre-order',
                              style: textMedium.copyWith(
                                color: selectedTab == 1
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ✅ المنتجات
          Expanded(
            child: Consumer<ProductController>(
              builder: (context, productController, child) {
                if (productController.brandOrCategoryProductList == null) {
                  return ProductShimmer(
                    isHomePage: false,
                    isEnabled:
                        productController.brandOrCategoryProductList == null,
                  );
                }
            
                return (productController
                            .brandOrCategoryProductList?.products?.isNotEmpty ??
                        false)
                    ? PaginatedListView(
                        scrollController: _scrollController,
                        onPaginate: (offset) => _loadProducts(offset: offset),
                        limit: productController
                            .brandOrCategoryProductList?.limit,
                        totalSize: productController
                            .brandOrCategoryProductList?.totalSize,
                        offset: productController
                            .brandOrCategoryProductList?.offset,
                        itemView: Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall)
                          .copyWith(top: Dimensions.paddingSizeExtraSmall),
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: (1 / 1.7),
        ),
                      itemCount: productController
                              .brandOrCategoryProductList?.products?.length ??
                          0,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductWidget(
                            productModel: productController
                                .brandOrCategoryProductList!.products![index]);
                      },
                    ),
                  ),
                      )
                    : const NoInternetOrDataScreenWidget(
                        isNoInternet: false,
                        icon: Images.noProduct,
                        message: 'no_product_found',
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
