import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/category_widgett.dart';
import 'package:gharsat_ward/common/basewidget/discount_tag_widget.dart';
import 'package:gharsat_ward/features/product/domain/models/product_model.dart';
import 'package:gharsat_ward/features/product_details/screens/product_details_screen.dart';
import 'package:gharsat_ward/helper/price_converter.dart';
import 'package:gharsat_ward/localization/controllers/localization_controller.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/theme/controllers/theme_controller.dart';
import 'package:gharsat_ward/utill/color_resources.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/common/basewidget/custom_image_widget.dart';
import 'package:gharsat_ward/features/product_details/widgets/favourite_button_widget.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product productModel;
  final int productNameLine;
  const ProductWidget(
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
        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              LayoutBuilder(
                builder: (context, boxConstraint) => ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radiusDefault),
                    topRight: Radius.circular(Dimensions.radiusDefault),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.paddingSizeSmall),
                          border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.10),
                              width: 1),
                          color: Theme.of(context).highlightColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.05),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Dimensions.paddingSizeEight),
                          child: CustomImageWidget(
                            image: '${productModel.thumbnailFullUrl?.path}',
                            fit: BoxFit.cover,
                            height: boxConstraint.maxWidth * 0.82,
                            width: boxConstraint.maxWidth,
                          ),
                        ),
                      ),
                      if (productModel.currentStock! == 0 &&
                          productModel.productType == 'physical') ...[
                        Container(
                          height: boxConstraint.maxWidth * 0.82,
                          width: boxConstraint.maxWidth,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: boxConstraint.maxWidth,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .error
                                      .withOpacity(0.4),
                                  borderRadius: const BorderRadius.only(
                                    topLeft:
                                        Radius.circular(Dimensions.radiusSmall),
                                    topRight:
                                        Radius.circular(Dimensions.radiusSmall),
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
              ),

              // Product Details - Aligned to the left
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Changed to start
                  children: [
                    if (ratting > 0)
                      Row(
                        children: [
                          const Icon(Icons.star_rate_rounded,
                              color: Colors.orange, size: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              ratting.toStringAsFixed(1),
                              style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault)),
                          ),
                          Text('(${productModel.reviewCount.toString()})',
                              style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).hintColor))
                        ],
                      ),
                    const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),

                    // Product Name - Aligned left
                    Text(
                      productModel.name ?? '',
                      textAlign: TextAlign.left, // Changed to left
                      style: textBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                      maxLines: productNameLine,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    // Price Section - Aligned left
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ((productModel.discount != null &&
                                    productModel.discount! > 0) ||
                                (productModel.clearanceSale?.discountAmount ??
                                        0) >
                                    0)
                            ? Container(   padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                              vertical: 1),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(60)),
                              child: Text(
                                  PriceConverter.convertPrice(
                                      context, productModel.unitPrice),
                                  style: titleRegular.copyWith(
                                      color: Theme.of(context).hintColor,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: Dimensions.fontSizeExtraSmall)),
                            )
                            : const SizedBox.shrink(),
                            SizedBox(height: 2,),
                        Container(   padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                              vertical: 1),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(60)),
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
                            style: textMedium.copyWith(
                                color: Color.fromARGB(255, 64, 64, 64), fontSize: Dimensions.fontSizeExtraSmall),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    // Product Details - Aligned left
                    // Wrap(
                    //   spacing: Dimensions.paddingSizeExtraSmall,
                    //   runSpacing: Dimensions.paddingSizeExtraSmall,
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: Dimensions.paddingSizeSmall,
                    //           vertical: 1),
                    //       decoration: BoxDecoration(
                    //           color: Colors.grey.withOpacity(0.2),
                    //           borderRadius: BorderRadius.circular(60)),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //            ListView.builder(
                    //           shrinkWrap: true,
                    //           itemCount: productModel!.choiceOptions!.length,
                    //           physics: const NeverScrollableScrollPhysics(),
                    //           itemBuilder: (context, index) {
                    //             return Row(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.center,
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Text(
                    //                       '${getTranslated('available', context)} ${productModel!.choiceOptions![index].title} :',
                    //                       style: titilliumRegular.copyWith(
                    //                           fontSize:
                    //                               Dimensions.fontSizeLarge)),
                    //                   const SizedBox(
                    //                       width:
                    //                           Dimensions.paddingSizeExtraSmall),
                    //                   Expanded(
                    //                       child: Padding(
                    //                           padding:
                    //                               const EdgeInsets.all(2.0),
                    //                           child: SizedBox(
                    //                               height: 40,
                    //                               child: ListView.builder(
                    //                                   scrollDirection:
                    //                                       Axis.horizontal,
                    //                                   shrinkWrap: true,
                    //                                   itemCount: productModel!
                    //                                       .choiceOptions![index]
                    //                                       .options!
                    //                                       .length,
                    //                                   itemBuilder:
                    //                                       (context, i) {
                    //                                     return Center(
                    //                                         child: Padding(
                    //                                             padding: const EdgeInsets.only(
                    //                                                 right: Dimensions
                    //                                                     .paddingSizeDefault),
                    //                                             child: Text(
                    //                                               "${ productModel!
                    //                                       .choiceOptions![index]
                    //                                       .options![i].trim()
                    //                                       ?? '50'}",
                    //                                                 maxLines: 1,
                    //                                                 overflow:
                    //                                                     TextOverflow
                    //                                                         .ellipsis,
                    //                                                 style: textRegular.copyWith(
                    //                                                     fontSize:
                    //                                                         Dimensions.fontSizeLarge,
                    //                                                     color: Provider.of<ThemeController>(context, listen: false).darkTheme ? const Color(0xFFFFFFFF) : Theme.of(context).primaryColor))));
                    //                                   })))),
                    //                 ]);
                    //           },
                    //         ),
                    //           Text("Length: ",
                    //               style: textMedium.copyWith(
                    //                   fontSize: Dimensions.fontSizeExtraSmall,
                    //                   color:const Color.fromARGB(255, 64, 64, 64) )),
                    //           Text("${productModel.choiceOptions?.length ?? '50'} cm",
                    //               style: textMedium.copyWith(
                    //                   color:  Color.fromARGB(255, 64, 64, 64).withOpacity(0.7), 
                    //                      fontSize: Dimensions.fontSizeExtraSmall)),
                    //         ],
                    //       ),
                    //     ),
           
                    //   ],
                    // ),
                   SizedBox(
  height: 30,
  child: GridView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 5,
    ),
    itemCount:productModel!.choiceOptions!.length,
    itemBuilder: (context, index) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: 1,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Text(
                '${productModel!.choiceOptions![index].title} :',
                style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: const Color.fromARGB(255, 64, 64, 64),
                ),
                softWrap: true,
              maxLines: 2,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Flexible(
              flex: 3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.hardEdge, // لتجنب overflow
                child: Row(
                  children: productModel!.choiceOptions![index].options!
                      .map((option) => Padding(
                            padding: const EdgeInsets.only(
                                right: Dimensions.paddingSizeExtraOverLarge),
                            child: Text(
                              option.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textMedium.copyWith(
                                color: const Color.fromARGB(255, 64, 64, 64)
                                    .withOpacity(0.7),
                                fontSize: Dimensions.fontSizeExtraSmall,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
)
, 
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    // Tags Section - Show tags if available
                    // if (productModel.tags != null && productModel.tags!.isNotEmpty) ...[
                    // Wrap(
                    //   spacing: Dimensions.paddingSizeExtraSmall,
                    //   runSpacing: Dimensions.paddingSizeExtraSmall,
                    //   children: productModel.tags!.map((tag) => Container(
                    //       padding: const EdgeInsets.symmetric(
                    //          horizontal: Dimensions.paddingSizeSmall,
                    //         vertical: 2),
                    //     decoration: BoxDecoration(
                    //         color: Theme.of(context).primaryColor.withOpacity(0.1),
                    //           borderRadius: BorderRadius.circular(12)),
                    //       child: Text(
                    //         tag,
                    //         style: textMedium.copyWith(
                    //             color: Theme.of(context).primaryColor,
                    //             fontSize: Dimensions.fontSizeExtraSmall),
                    //       ),
                    //     )).toList(),
                    //   ),
                    //   const SizedBox(height: Dimensions.paddingSizeSmall),
                    // ],

                    Row( 
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(  children: [
                      Icon(Icons.shopping_cart_checkout,
                      color:Theme.of(context).primaryColor,size:Dimensions.fontSizeSmall ,),
                      Text(" ${productModel.currentStock}",style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),)
                    ]),
                     Row(  children: [
                      Icon(Icons.fire_truck_outlined,color:Theme.of(context).primaryColor,size:Dimensions.fontSizeSmall ,),
                      Text("  ${productModel.shippingMethod?.deliveryDate??"2025-07-13"}"
                      ,style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),)
                    ])]
                    )
                  ],
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

          // Tags - Show at top-left if available
          if (productModel.tags != null && productModel.tags!.isNotEmpty)
            Positioned(
              top: 40,
              left: isLtr ? -5 : null,
              right: !isLtr ? -5: null,
              child: Wrap(
                spacing: 89,
               
                children: productModel.tags!.take(2).map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag.tag,
                    style: textMedium.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeExtraSmall,
                    ),
                  ),
                )).toList(),
              ),
            ),
        ]),
      ),
    );
  }
}