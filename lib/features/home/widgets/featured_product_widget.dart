import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/product_user_widget.dart';
import 'package:gharsat_ward/common/basewidget/product_widget.dart';
import 'package:gharsat_ward/common/basewidget/slider_product_shimmer_widget.dart';
import 'package:gharsat_ward/common/basewidget/title_row_widget.dart';
import 'package:gharsat_ward/features/auth/controllers/auth_controller.dart' show AuthController;
import 'package:gharsat_ward/features/product/controllers/product_controller.dart';
import 'package:gharsat_ward/features/product/enums/product_type.dart';
import 'package:gharsat_ward/features/product/screens/view_all_product_screen.dart';
import 'package:gharsat_ward/helper/responsive_helper.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/product_widget.dart';
import 'package:gharsat_ward/common/basewidget/slider_product_shimmer_widget.dart';
import 'package:gharsat_ward/common/basewidget/title_row_widget.dart';
import 'package:gharsat_ward/features/product/controllers/product_controller.dart';
import 'package:gharsat_ward/features/product/enums/product_type.dart';
import 'package:gharsat_ward/features/product/screens/view_all_product_screen.dart';
import 'package:gharsat_ward/helper/responsive_helper.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:provider/provider.dart';

class FeaturedProductWidget extends StatelessWidget {
  const FeaturedProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, productController, _) {
        return ((productController.featuredProductList != null &&
                productController.featuredProductList!.isNotEmpty))
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraSmall,
                      vertical: Dimensions.paddingSizeExtraSmall,
                    ),
                    child: TitleRowWidget(
                      title: getTranslated('featured_products', context),
                      
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllProductScreen(
                            productType: ProductType.featuredProduct,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(), // إلغاء التمرير
                    shrinkWrap: true, // ضروري عند استخدامه داخل ListView
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
                      childAspectRatio:Provider.of<AuthController>(Get.context!, listen: false).getUserToken()==""?0.62: 0.5, // نسبة الطول إلى العرض
                      mainAxisSpacing: 10, // تباعد عمودي
                      crossAxisSpacing: 10, // تباعد أفقي
                    ),
                    itemCount: productController.featuredProductList?.length,
                    itemBuilder: (context, index) {
                      return Provider.of<AuthController>(Get.context!, listen: false).getUserToken()==""?
                      ProductWidget(
                        productModel: productController.featuredProductList![index],
                        productNameLine: 1,
                      ):ProductUserWidget(productModel:productController.featuredProductList![index] ,productNameLine: 1,)
                      ;
                    },
                  ),
                ],
              )
            : productController.featuredProductList == null
                ? const SliderProductShimmerWidget()
                : const SizedBox();
      },
    );
  }
}