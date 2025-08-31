import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/product_user_widget.dart'
    show ProductUserWidget;
import 'package:gharsat_ward/common/basewidget/product_widget.dart';
import 'package:gharsat_ward/features/auth/controllers/auth_controller.dart'
    show AuthController;
import 'package:gharsat_ward/features/deal/controllers/flash_deal_controller.dart';
import 'package:gharsat_ward/helper/responsive_helper.dart';
import 'package:gharsat_ward/common/basewidget/slider_product_widget.dart';
import 'package:gharsat_ward/features/home/shimmers/flash_deal_shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gharsat_ward/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/product_widget.dart';
import 'package:gharsat_ward/features/deal/controllers/flash_deal_controller.dart';
import 'package:gharsat_ward/helper/responsive_helper.dart';
import 'package:gharsat_ward/common/basewidget/slider_product_widget.dart';
import 'package:gharsat_ward/features/home/shimmers/flash_deal_shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class FlashDealsListWidget extends StatelessWidget {
  final bool isHomeScreen;
  const FlashDealsListWidget({super.key, this.isHomeScreen = true});

  @override
  Widget build(BuildContext context) {
    return isHomeScreen
        ? Consumer<FlashDealController>(
            builder: (context, flashDealController, child) {
            return flashDealController.flashDeal != null
                ? flashDealController.flashDealList.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              ResponsiveHelper.isTab(context) ? 3 : 2,
                          childAspectRatio: Provider.of<AuthController>(
                                          Get.context!,
                                          listen: false)
                                      .getUserToken() ==
                                  ""
                              ? 0.62
                              : 0.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: flashDealController.flashDealList.length,
                        itemBuilder: (context, index) {
                          return Provider.of<AuthController>(Get.context!,
                                          listen: false)
                                      .getUserToken() ==
                                  ""
                              ? ProductWidget(
                                  productModel:
                                      flashDealController.flashDealList[index],
                                  productNameLine: 1,
                                )
                              : ProductUserWidget(
                                  productModel:
                                      flashDealController.flashDealList[index],
                                  productNameLine: 1,
                                );
                        },
                      )
                    : const SizedBox()
                : const FlashDealShimmer();
          })
        : Consumer<FlashDealController>(
            builder: (context, flashDealController, child) {
              return flashDealController.flashDealList.isNotEmpty
                  ? RepaintBoundary(
                      child: MasonryGridView.count(
                        itemCount: flashDealController.flashDealList.length,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (BuildContext context, int index) {
                          return Provider.of<AuthController>(Get.context!,
                                          listen: false)
                                      .getUserToken() ==
                                  ""
                              ? ProductWidget(
                                  productModel:
                                      flashDealController.flashDealList[index],
                                  productNameLine: 1,
                                )
                              : ProductUserWidget(
                                  productModel:
                                      flashDealController.flashDealList[index],
                                  productNameLine: 1,
                                );
                        },
                        crossAxisCount: 2,
                      ),
                    )
                  : const Center(child: CircularProgressIndicator());
            },
          );
  }
}
