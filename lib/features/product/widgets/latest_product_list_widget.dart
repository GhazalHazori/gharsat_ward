import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/product_user_widget.dart';
import 'package:gharsat_ward/common/basewidget/product_widget.dart';
import 'package:gharsat_ward/common/basewidget/slider_product_shimmer_widget.dart';
import 'package:gharsat_ward/features/auth/controllers/auth_controller.dart';
import 'package:gharsat_ward/features/product/controllers/product_controller.dart';
import 'package:gharsat_ward/features/product/screens/view_all_product_screen.dart';
import 'package:gharsat_ward/features/product/enums/product_type.dart';
import 'package:gharsat_ward/helper/responsive_helper.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/common/basewidget/title_row_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/product_widget.dart';
import 'package:gharsat_ward/common/basewidget/slider_product_shimmer_widget.dart';
import 'package:gharsat_ward/features/product/controllers/product_controller.dart';
import 'package:gharsat_ward/features/product/screens/view_all_product_screen.dart';
import 'package:gharsat_ward/features/product/enums/product_type.dart';
import 'package:gharsat_ward/helper/responsive_helper.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/common/basewidget/title_row_widget.dart';
import 'package:provider/provider.dart';

class LatestProductListWidget extends StatelessWidget {
  const LatestProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(builder: (context, prodProvider, child) {
      return (prodProvider.latestProductList?.isNotEmpty ?? false)
          ? Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraSmall),
                child: TitleRowWidget(
                  title: getTranslated('latest_products', context),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AllProductScreen(
                              productType: ProductType.latestProduct))),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
                  childAspectRatio:
                      Provider.of<AuthController>(Get.context!, listen: false)
                                  .getUserToken() ==
                              ""
                          ? 0.62
                          : 0.5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: prodProvider.latestProductList?.length,
                itemBuilder: (context, index) {
                  return Provider.of<AuthController>(Get.context!,
                                  listen: false)
                              .getUserToken() ==
                          ""
                      ? ProductWidget(
                          productModel: prodProvider.latestProductList![index],
                          productNameLine: 1,
                        )
                      : ProductUserWidget(
                          productModel: prodProvider.latestProductList![index],
                          productNameLine: 1,
                        );
                },
              ),
            ])
          : prodProvider.latestProductList == null
              ? const SliderProductShimmerWidget()
              : const SizedBox();
    });
  }
}
