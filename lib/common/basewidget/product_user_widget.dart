import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/category_widgett.dart';
import 'package:gharsat_ward/common/basewidget/discount_tag_widget.dart';
import 'package:gharsat_ward/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:gharsat_ward/features/cart/controllers/cart_controller.dart';
import 'package:gharsat_ward/features/cart/domain/models/cart_model.dart';
import 'package:gharsat_ward/features/cart/screens/cart_screen.dart';
import 'package:gharsat_ward/features/product/domain/models/product_model.dart';
import 'package:gharsat_ward/features/product_details/controllers/product_details_controller.dart';
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

class ProductUserWidget extends StatefulWidget {
  final Product productModel;
  final int productNameLine;
  const ProductUserWidget(
      {super.key, required this.productModel, this.productNameLine = 2});

  @override
  State<ProductUserWidget> createState() => _ProductUserWidgetState();
}

class _ProductUserWidgetState extends State<ProductUserWidget> {
  int _quantity = 0;
  late int _minQuantity;
  late int _defaultMultiplier;
  int _step = 1; // مقدار الزيادة/النقصان

  @override
void initState() {
  super.initState();
  if (widget.productModel != null) {
    int minQty = widget.productModel.minimumOrderQuantity ?? 0;
    _minQuantity = minQty > 0 ? minQty : 100;
    _defaultMultiplier = widget.productModel.isMultiPly ?? 100;
    _quantity = 0; // القيمة الافتراضية صفر
  } else {
    _minQuantity = 100;
    _defaultMultiplier = 100;
    _quantity = 0; // القيمة الافتراضية صفر
  }
}
  bool _isSameShippingMethod(CartController cartController) {
    // Assuming each product has a shippingMethodId property
    if (cartController.cartList.isEmpty) return true;
    int currentShippingMethodId = widget.productModel!.shippingMethod!.id!;
    return cartController.cartList.every((cartItem) =>
        cartItem.productInfo!.
        shippingMethod!.id == currentShippingMethodId);
  }

  Widget build(BuildContext context) {
    final bool isLtr =
        Provider.of<LocalizationController>(context, listen: false).isLtr;
    double ratting = 0;
    if (widget.productModel.rating != null &&
        widget.productModel.rating!.isNotEmpty) {
      try {
        ratting = double.parse('${widget.productModel.rating![0].average}');
      } catch (e) {
        ratting = 0;
      }
    }

    return InkWell(
      onTap: () {
        if (mounted) {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (context, anim1, anim2) => ProductDetails(
                      productId: widget.productModel.id,
                      slug: widget.productModel.slug,
                      selectedQuantity: _quantity * _minQuantity)));
        }
      },
      child: Container(
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
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeSmall),
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
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeEight),
                          child: CustomImageWidget(
                            image:
                                '${widget.productModel.thumbnailFullUrl?.path}',
                            fit: BoxFit.cover,
                            height: boxConstraint.maxWidth * 0.82,
                            width: boxConstraint.maxWidth,
                          ),
                        ),
                      ),
                      if (widget.productModel.currentStock == 0 &&
                          widget.productModel.productType == 'physical') ...[
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Changed to start
                  children: [
                    if (ratting > 0)
                      Row(
                        children: [
                          const Icon(Icons.star_rate_rounded,
                              color: Colors.orange, size: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(ratting.toStringAsFixed(1),
                                style: textRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault)),
                          ),
                          Text(
                              '(${widget.productModel.reviewCount?.toString() ?? '0'})',
                              style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).hintColor))
                        ],
                      ),
                    const SizedBox(
                        height: Dimensions.paddingSizeExtraExtraSmall),

                    // Product Name - Aligned left
                    Text(
                      widget.productModel.name ?? '',
                      textAlign: TextAlign.left, // Changed to left
                      style: textBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                      maxLines: widget.productNameLine,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    // Price Section - Aligned left
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ((widget.productModel.discount != null &&
                                    widget.productModel.discount! > 0) ||
                                (widget.productModel.clearanceSale
                                            ?.discountAmount ??
                                        0) >
                                    0)
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: 1),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(60)),
                                child: Text(
                                    PriceConverter.convertPrice(
                                        context, widget.productModel.unitPrice),
                                    style: titleRegular.copyWith(
                                        color: Theme.of(context).hintColor,
                                        decoration: TextDecoration.lineThrough,
                                        fontSize:
                                            Dimensions.fontSizeExtraSmall)),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                              vertical: 1),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(60)),
                          child: Text(
                            PriceConverter.convertPrice(
                              context,
                              widget.productModel.unitPrice,
                              discountType: (widget.productModel.clearanceSale
                                              ?.discountAmount ??
                                          0) >
                                      0
                                  ? widget
                                      .productModel.clearanceSale?.discountType
                                  : widget.productModel.discountType,
                              discount: (widget.productModel.clearanceSale
                                              ?.discountAmount ??
                                          0) >
                                      0
                                  ? widget.productModel.clearanceSale
                                      ?.discountAmount
                                  : widget.productModel.discount,
                            ),
                            style: textMedium.copyWith(
                                color: Color.fromARGB(255, 64, 64, 64),
                                fontSize: Dimensions.fontSizeExtraSmall),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
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
    itemCount: widget.productModel!.choiceOptions!.length,
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
                '${widget.productModel!.choiceOptions![index].title} :',
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
                  children: widget.productModel!.choiceOptions![index].options!
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
                          
                    //           Text("Length: ",
                    //               style: textMedium.copyWith(
                    //                   fontSize: Dimensions.fontSizeExtraSmall,
                    //                   color: const Color.fromARGB(
                    //                       255, 64, 64, 64))),
                    //           Text(
                    //               "${widget.productModel.details?.length ?? '50'} cm",
                    //               style: textMedium.copyWith(
                    //                   color: Color.fromARGB(255, 64, 64, 64)
                    //                       .withOpacity(0.7),
                    //                   fontSize: Dimensions.fontSizeExtraSmall)),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Icon(
                              Icons.shopping_cart_checkout,
                              color: Theme.of(context).primaryColor,
                              size: Dimensions.fontSizeSmall,
                            ),
                            Text(
                              " ${widget.productModel.currentStock?.toString() ?? '0'}",
                              style: textMedium.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall),
                            )
                          ]),
                          Row(children: [
                            Icon(
                              Icons.fire_truck_outlined,
                              color: Theme.of(context).primaryColor,
                              size: Dimensions.fontSizeSmall,
                            ),
                            Text(
                              "  ${widget.productModel.shippingMethod?.deliveryDate ?? "2025-07-13"}",
                              style: textMedium.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall),
                            )
                          ])
                        ]),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bundle size indicator and quick buttons in one row
                        Row(
                          children: [
                            // Bundle size indicator
                            Row(
                              children: [
                                Icon(
                                  Icons.inventory_sharp,
                                  color: Theme.of(context).primaryColor,
                                  size: 15,
                                ),
                                // const SizedBox(width: 2),
                                Text(
                                  "${ _minQuantity}x",
                                  style: textMedium.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            // Quick quantity buttons
                            Row(
                              children: [
                                _buildQuantityButton(1, 1 == _step),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                _buildQuantityButton(5, 5 == _step),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                _buildQuantityButton(10, 10 == _step),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),

                        // Manual quantity selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraLarge),
                             _buildQuantityControlButton(
              icon: Icons.remove,
              onPressed: () {
                int prevQuantity = _quantity - _step;
                if (prevQuantity < 0) {
                  prevQuantity = 0;
                }
                if (_quantity > 0) {
                  setState(() {
                    _quantity = prevQuantity;
                  });
                  Provider.of<ProductDetailsController>(context, listen: false)
                      .setQuantity(_quantity * _minQuantity);
                }
              },
            ),
                                 Container(
              width: 30,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: Center(
                child: Text(
                  ( _quantity * _minQuantity).toString(),
                  textAlign: TextAlign.center,
                  style: textMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            _buildQuantityControlButton(
              icon: Icons.add,
              onPressed: () {
                int nextQuantity = _quantity + _step; 
                 int? stock = widget.productModel!.currentStock;
                   double? digitalVariantPrice; String? variantKey;
                    Variation? variation;
                    CartModelBody cart = CartModelBody(
                  productId: widget.productModel!.id,
                  variant: (widget.productModel!.colors != null &&
                          widget.productModel!.colors!.isNotEmpty)
                      ? widget.productModel!.colors![0].name
                      : '',
                  color: (widget.productModel!.colors != null &&
                          widget.productModel!.colors!.isNotEmpty)
                      ? widget.productModel!.colors![0].code
                      : '',
                  variation: variation,
                  quantity: nextQuantity * _minQuantity,
                  variantKey: variantKey,
                  digitalVariantPrice: digitalVariantPrice);
                setState(() {
                  _quantity = nextQuantity;
                });
                Provider.of<ProductDetailsController>(context, listen: false)
                    .setQuantity(_quantity * _minQuantity);
                     if (stock! <
                                                      widget.productModel!
                                                          .minimumOrderQuantity! &&
                                                  widget.productModel!.productType ==
                                                      "physical") {
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'out_of_stock',
                                                        context),
                                                    context);
                                              } else if (stock >=
                                                      widget.productModel!
                                                          .minimumOrderQuantity! ||
                                                  widget.productModel!.productType ==
                                                      "digital") {
                                                         final cartController =
                    Provider.of<CartController>(context, listen: false);
                if (_isSameShippingMethod(cartController)) {
                                                Provider.of<CartController>(
                                                        context,
                                                        listen: false)
                                                    .addToCartAPI(
                                                        cart,
                                                        context,
                                                        widget.productModel!
                                                            .choiceOptions!,
                                                        [0,0,
                                                        widget.productModel.shippingMethod!.id!.toInt(),]);} else {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(getTranslated(
                                'different_shipping_method', context)!,style: textMedium.copyWith(fontSize: 15),),
                            content: Text(getTranslated(
                                'clear_cart_or_proceed_to_checkout', context)!,style: textMedium.copyWith(fontSize: 12),),
                            actions: [
                              // TextButton(
                              //   onPressed: () {
                              //     cartController.cartList.clear;
                              //     Navigator.of(context).pop();
                              //   },
                              //   child: Text(getTranslated('clear_cart', context)!),
                              // ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Navigate to checkout screen
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>CartScreen()));
                                },
                                child: Text(getTranslated('proceed_to_checkout', context)!,style: textBold.copyWith(fontSize: 12),),
                              ),
                            ],
                          ));
                }
                                              }
              },
            ),
                          ],
                        ),

                        // Add to cart button
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Discount Tag
          ((widget.productModel.discount != null &&
                      widget.productModel.discount! > 0) ||
                  (widget.productModel.clearanceSale != null))
              ? Positioned(
                  top: 12,
                  right: isLtr ? 12 : null,
                  left: !isLtr ? 12 : null,
                  child: DiscountTagWidget(productModel: widget.productModel),
                )
              : const SizedBox.shrink(),

          // Category Tag
          Positioned(
            top: 12,
            right: isLtr ? 2 : null,
            left: !isLtr ? 2 : null,
            child: CategoryWidgett(productModel: widget.productModel),
          ),

          // Tags - Show at top-left if available
          if (widget.productModel.tags != null &&
              widget.productModel.tags!.isNotEmpty)
            Positioned(
              top: 40,
              left: isLtr ? -5 : null,
              right: !isLtr ? -5 : null,
              child: Wrap(
                spacing: 89,
                children: widget.productModel.tags!
                    .take(2)
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag.tag,
                            style: textMedium.copyWith(
                              color: Colors.white,
                              fontSize: Dimensions.fontSizeExtraSmall,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _buildQuantityButton(int quantity, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _step = quantity; // فقط غير مقدار الزيادة
        });
      },
      child: Container(
        width: 28,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            quantity.toString(),
            style: textMedium.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  void _addToCart() {
    try {
      // Validate product model
      if (widget.productModel == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في بيانات المنتج'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Check if product is in stock
      if (widget.productModel.currentStock == 0 &&
          widget.productModel.productType == 'physical') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('المنتج غير متوفر في المخزون'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Check minimum order quantity and multiply by selected quantity
      int minOrderQty = widget.productModel.minimumOrderQuantity ?? 1;
      int actualQuantity = _quantity * minOrderQty;

      if (actualQuantity < minOrderQty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('الحد الأدنى للطلب هو $minOrderQty'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Check if quantity is available
      if (widget.productModel.productType == 'physical' &&
          widget.productModel.currentStock != null &&
          _quantity > widget.productModel.currentStock!) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('الكمية المطلوبة غير متوفرة في المخزون'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Create cart model body
      CartModelBody cart = CartModelBody(
        productId: widget.productModel.id,
        quantity: actualQuantity,
        color: '',
        variant: '',
        variation: Variation(),
        variantKey: null,
        digitalVariantPrice: 0,
      );

      // Add to cart using CartController
      if (mounted) {
        Provider.of<CartController>(context, listen: false).addToCartAPI(
          cart,
          context,
          widget.productModel.choiceOptions ?? [],
          [], // Empty variation indexes for simple products
        ).then((value) {
          if (mounted) {
            if (value != null &&
                value.response != null &&
                value.response!.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إضافة المنتج إلى السلة بنجاح'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('حدث خطأ أثناء إضافة المنتج إلى السلة'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        }).catchError((error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('حدث خطأ: $error'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ غير متوقع: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildQuantityControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 10,
        ),
      ),
    );
  }
}
