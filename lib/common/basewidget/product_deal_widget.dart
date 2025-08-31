import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/category_widgett.dart';
import 'package:gharsat_ward/common/basewidget/discount_tag_widget.dart';
import 'package:gharsat_ward/features/product/domain/models/product_model.dart';
import 'package:gharsat_ward/features/product_details/screens/product_details_screen.dart';
import 'package:gharsat_ward/helper/price_converter.dart';
import 'package:gharsat_ward/localization/controllers/localization_controller.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/utill/color_resources.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/common/basewidget/custom_image_widget.dart';
import 'package:gharsat_ward/features/product_details/widgets/favourite_button_widget.dart';
import 'package:provider/provider.dart';

class ProductDealWidget extends StatelessWidget {
  final Product productModel;
  final int productNameLine;
  const ProductDealWidget(
      {super.key, required this.productModel, this.productNameLine = 2});

  @override
  Widget build(BuildContext context) {
    final bool isLtr =
        Provider.of<LocalizationController>(context, listen: false).isLtr;
    double ratting = (productModel.rating?.isNotEmpty ?? false)
        ? double.parse('${productModel.rating?[0].average}')
        : 0;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 1000),
                pageBuilder: (context, anim1, anim2) => ProductDetails(
                    productId: productModel.id, slug: productModel.slug)));
      },
      child: Container(
       width: 900,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(.10), width: 1),
          color: Theme.of(context).highlightColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(9, 5),
            )
          ],
        ),
        child: Stack(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section - Fixed size
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(.10),
                      width: 1),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        image: '${productModel.thumbnailFullUrl?.path}',
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
                    ),
                    if (productModel.currentStock! == 0 &&
                        productModel.productType == 'physical') ...[
                      Container(
                        height: 100,
                        width: 100,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(0.4),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                )),
                            child: Text(
                              getTranslated('out_of_stock', context) ?? '',
                              style: textBold.copyWith(
                                  color: Colors.white,
                                  fontSize: Dimensions.fontSizeSmall),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Product Details - Takes remaining space
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ratting > 0)
                        Row(
                          children: [
                            const Icon(Icons.star_rate_rounded,
                                color: Colors.orange, size: 16),
                            Text(
                              ratting.toStringAsFixed(1),
                              style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall)),
                            Text(' (${productModel.reviewCount.toString()})',
                                style: textRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Theme.of(context).hintColor))
                          ],
                        ),
                      const SizedBox(height: 4),

                      // Product Name
                      Text(
                        productModel.name ?? '',
                        style: textMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                        maxLines: productNameLine,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Price Section in Row
                      Row(
                        children: [
                          if (((productModel.discount != null &&
                                      productModel.discount! > 0) ||
                                  (productModel.clearanceSale?.discountAmount ??
                                          0) >
                                      0))
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                  PriceConverter.convertPrice(
                                      context, productModel.unitPrice),
                                  style: titleRegular.copyWith(
                                      color: Theme.of(context).hintColor,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: Dimensions.fontSizeExtraSmall)),
                            ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              PriceConverter.convertPrice(
                                context,
                                productModel.unitPrice,
                                discountType: (productModel.clearanceSale
                                                ?.discountAmount ??
                                            0) >
                                        0
                                    ? productModel.clearanceSale?.discountType
                                    : productModel.discountType,
                                discount: (productModel.clearanceSale
                                                ?.discountAmount ??
                                            0) >
                                        0
                                    ? productModel.clearanceSale?.discountAmount
                                    : productModel.discount,
                              ),
                              style: robotoBold.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Product Details
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          "Length: ${productModel.details?.length ?? '50'} cm",
                          style: textMedium.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Stock and Delivery
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_checkout,
                                  color: Theme.of(context).primaryColor,
                                  size: 14),
                              const SizedBox(width: 2),
                              Text("${productModel.currentStock}",
                                  style: textMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall)),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.delivery_dining_rounded,
                                  color: Theme.of(context).primaryColor,
                                  size: 14),
                              const SizedBox(width: 2),
                              Text("${productModel.shippingMethod?.deliveryDate }",
                                  style: textMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Discount Tag
          ((productModel.discount! > 0) || (productModel.clearanceSale != null))
              ? Positioned(
                  top: 12,
                  right: isLtr ? 12 : null,
                  left: !isLtr ? 12 : null,
                  child: DiscountTagWidget(productModel: productModel),
                )
              : const SizedBox.shrink(),

          // Category Tag
          Positioned(
            top: 12,
            right: isLtr ? 2 : null,
            left: !isLtr ? 2 : null,
            child:
             CategoryWidgett(
           productModel: productModel
            ),
          ),
        ]),
      ),
    );
  }
}