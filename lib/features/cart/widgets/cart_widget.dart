import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/custom_loader_widget.dart';
import 'package:gharsat_ward/features/cart/domain/models/cart_model.dart';
import 'package:gharsat_ward/features/cart/widgets/cart_quantity_button_widget.dart';
import 'package:gharsat_ward/features/product_details/controllers/product_details_controller.dart';
import 'package:gharsat_ward/helper/price_converter.dart';
import 'package:gharsat_ward/localization/controllers/localization_controller.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/features/cart/controllers/cart_controller.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/utill/color_resources.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/common/basewidget/custom_image_widget.dart';
import 'package:gharsat_ward/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatefulWidget {
  final CartModel? cartModel;
  final int index;
  final bool fromCheckout;
  const CartWidget(
      {super.key,
      this.cartModel,
      required this.index,
      required this.fromCheckout});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
    int _quantity = 0;
  late int _minQuantity;
  late int _defaultMultiplier;
  int _step = 1; // مقدار الزيادة/النقصان

//   @override
// void initState() {
//   super.initState();
//   if (widget.productModel != null) {
//     int minQty = widget.productModel.minimumOrderQuantity ?? 0;
//     _minQuantity = minQty > 0 ? minQty : 100;
//     _defaultMultiplier = widget.productModel.isMultiPly ?? 100;
//     _quantity = 0; // القيمة الافتراضية صفر
//   } else {
//     _minQuantity = 100;
//     _defaultMultiplier = 100;
//     _quantity = 0; // القيمة الافتراضية صفر
//   }
// }
  
  Widget build(BuildContext context) {

    return Consumer<CartController>(builder: (context, cartProvider, _) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,
            Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, 0),
        child: Slidable(
          key: const ValueKey(0),
          endActionPane: ActionPane(
              extentRatio: .25,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                    onPressed: (value) {
                      cartProvider.removeFromCartAPI(widget.cartModel?.id, widget.index);
                    },
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .error
                        .withValues(alpha: .05),
                    foregroundColor: Theme.of(context).colorScheme.error,
                    icon: CupertinoIcons.delete_solid,
                    label: getTranslated('delete', context))
              ]),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius:
                    BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                border: Border.all(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.15),
                    width: .75)),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 0,
                    left: Provider.of<LocalizationController>(context,
                                listen: false)
                            .isLtr
                        ? Dimensions.paddingSizeSmall
                        : Dimensions.paddingSizeExtraSmall,
                    right: Provider.of<LocalizationController>(context,
                                listen: false)
                            .isLtr
                        ? Dimensions.paddingSizeExtraSmall
                        : Dimensions.paddingSizeSmall),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                    key: UniqueKey(),
                    visualDensity: VisualDensity.compact,
                    side: WidgetStateBorderSide.resolveWith((states) =>
                        BorderSide(
                            width: 2,
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.10))),
                    checkColor: Colors.white,
                    value: widget.cartModel!.isChecked!,
                    onChanged: (bool? value) async {
                      showDialog(
                          context: context,
                          builder: (ctx) => const CustomLoaderWidget());
                      await cartProvider.addRemoveCartSelectedItem(
                          [widget.cartModel!.id!],
                          widget.cartModel!.isChecked! ? false : true);
                      Navigator.of(Get.context!).pop();
                    },
                  ),
                ),
              ),
              Expanded(
                  child: IntrinsicHeight(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeSmall,
                              horizontal: 0),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 1000),
                                        pageBuilder: (context, anim1, anim2) =>
                                            ProductDetails(
                                                productId: widget.cartModel?.productId,
                                                slug: widget.cartModel?.slug)));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.paddingSizeExtraSmall),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withValues(alpha: .10),
                                              width: 0.5)),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.paddingSizeExtraSmall),
                                          child: CustomImageWidget(
                                              image:
                                                  '${widget.cartModel?.productInfo?.thumbnailFullUrl?.path}',
                                              height: 70,
                                              width: 70))),
                                  if (widget.cartModel!.isProductAvailable! == 0)
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.paddingSizeExtraSmall),
                                          color: Colors.black
                                              .withValues(alpha: .5)),
                                      height: 70,
                                      width: 70,
                                      child: Center(
                                        child: Text(
                                          "${getTranslated("not_available", context)}",
                                          textAlign: TextAlign.center,
                                          style: textMedium.copyWith(
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                ],
                              ))),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                  vertical: Dimensions.paddingSizeSmall),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(children: [
                                      Expanded(
                                          child: Text(
                                        widget.cartModel!.name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textMedium.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: (widget.cartModel!.shop != null &&
                                                  (widget.cartModel!.shop!
                                                          .temporaryClose! ||
                                                      widget.cartModel!.shop!
                                                          .vacationStatus!))
                                              ? Theme.of(context).hintColor
                                              : ColorResources
                                                  .getReviewRattingColor(
                                                      context),
                                        ),
                                      )),
                                      const SizedBox(
                                          width: Dimensions.paddingSizeSmall),
                                    ]),
                                    const SizedBox(
                                      height: Dimensions.paddingSizeSmall,
                                    ),

                                    widget.cartModel!.discount! > 0
                                        ? Text(
                                            PriceConverter.convertPrice(
                                                context, widget.cartModel!.price),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: titilliumSemiBold.copyWith(
                                                color:
                                                    Theme.of(context).hintColor,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                          )
                                        : const SizedBox(),

                                    Text(
                                      PriceConverter.convertPrice(
                                        context,
                                        widget.cartModel!.price,
                                        discount: widget.cartModel!.discount,
                                        discountType: 'amount',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textBold.copyWith(
                                        color: (widget.cartModel!.shop != null &&
                                                (widget.cartModel!.shop!
                                                        .temporaryClose! ||
                                                    widget.cartModel!
                                                        .shop!.vacationStatus!))
                                            ? Theme.of(context).hintColor
                                            : ColorResources.getPrimary(
                                                context),
                                        fontSize: Dimensions.fontSizeDefault,
                                      ),
                                    ),

                                    //variation
                                    (widget.cartModel!.variant != null &&
                                            widget.cartModel!.variant!.isNotEmpty)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: Row(children: [
                                              Flexible(
                                                  child: Text(
                                                      widget.cartModel?.variant ?? '',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: textRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          color: ColorResources
                                                              .getReviewRattingColor(
                                                                  context))))
                                            ]))
                                        : const SizedBox(),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          widget.cartModel!.shippingType !=
                                                  'order_wise'
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child: Row(children: [
                                                    Text(
                                                        '${getTranslated('shipping_cost', context)}: ',
                                                        style: titilliumSemiBold.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: (widget.cartModel!.shop !=
                                                                        null &&
                                                                    (widget.cartModel!
                                                                            .shop!
                                                                            .temporaryClose! ||
                                                                        widget.cartModel!
                                                                            .shop!
                                                                            .vacationStatus!))
                                                                ? Theme.of(
                                                                        context)
                                                                    .hintColor
                                                                : ColorResources
                                                                    .getReviewRattingColor(
                                                                        context))),
                                                    Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                context,
                                                                widget.cartModel!
                                                                    .shippingCost),
                                                        style: textRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor))
                                                  ]))
                                              : const SizedBox()
                                        ]),

                                    widget.cartModel!.taxModel == 'exclude'
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: Text(
                                              '(${getTranslated('tax', context)} : ${PriceConverter.convertPrice(context, widget.cartModel?.tax)})',
                                              style: textRegular.copyWith(
                                                  color: ColorResources
                                                      .hintTextColor,
                                                  fontSize: Dimensions
                                                      .fontSizeDefault),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: Text(
                                                '(${getTranslated('tax', context)} ${widget.cartModel!.taxModel})',
                                                style: textRegular.copyWith(
                                                    color: ColorResources
                                                        .hintTextColor,
                                                    fontSize: Dimensions
                                                        .fontSizeDefault))),
                                    if (widget.cartModel!.quantity! >
                                            widget.cartModel!.productInfo!
                                                .totalCurrentStock! &&
                                        widget.cartModel?.productType == "physical")
                                      Text(
                                        "${getTranslated("out_of_stock", context)}",
                                        style: textRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      )
                                  ]))),
                              Container(      decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: .05),
                            border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: .075)),
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(
                                    Dimensions.paddingSizeExtraSmall),
                                topRight: Radius.circular(
                                    Dimensions.paddingSizeExtraSmall))),
                        width: 40,child: Padding(
                          padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeSmall),
                          child: Column(children: [    _buildQuantityButton(1, 1 == _step),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall),
                                _buildQuantityButton(5, 5 == _step),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall),
                                _buildQuantityButton(10, 10 == _step),],),
                        ),),    
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: .05),
                            border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: .075)),
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(
                                    Dimensions.paddingSizeExtraSmall),
                                topRight: Radius.circular(
                                    Dimensions.paddingSizeExtraSmall))),
                        width: 40,
                        // height: (cartModel!.shippingType !='order_wise' && cartModel!.variant != null && cartModel!.variant!.isNotEmpty)? 185 : (cartModel!.variant != null && cartModel!.variant!.isNotEmpty &&  cartModel!.shippingType =='order_wise')? 125 : (cartModel!.variant == null &&  cartModel!.shippingType !='order_wise')? 160 : 150,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeSmall),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  widget.cartModel!.increment!
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  strokeWidth: 2)),
                                        )
                                      : CartQuantityButton(
                                          index: widget.index,
                                          isIncrement: true,
                                          step: _step,
                                          quantity: widget.cartModel!.quantity ,
                                          maxQty: widget.cartModel!
                                              .productInfo?.totalCurrentStock,
                                          cartModel: widget.cartModel,
                                          minimumOrderQuantity: widget.cartModel!
                                              .productInfo!.minimumOrderQty,
                                          digitalProduct:
                                              widget.cartModel!.productType ==
                                                      "digital"
                                                  ? true
                                                  : false),
                                  Text(widget.cartModel!.quantity.toString(),
                                      style: textRegular),
                                  widget.cartModel!.decrement!
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                strokeWidth: 2,
                                              )),
                                        )
                                      : CartQuantityButton(
                                          isIncrement: false,
                                          step: _step,
                                          index: widget.index,
                                          quantity: widget.cartModel!.quantity ,
                                          maxQty: widget.cartModel!
                                              .productInfo!.totalCurrentStock,
                                          cartModel: widget.cartModel,
                                          minimumOrderQuantity: widget.cartModel!
                                              .productInfo!.minimumOrderQty,
                                          digitalProduct:
                                              widget.cartModel!.productType ==
                                                      "digital"
                                                  ? true
                                                  : false)
                                ])),
                      ),
                    ]),
              ))
            ]),
          ),
        ),
      );
    });
    
  }

 Widget _buildQuantityButton(int quantity, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _step = quantity; // Update increment value
        });
        // Update the controller with current quantity
        Provider.of<ProductDetailsController>(context, listen: false)
            .setQuantity(_quantity * _minQuantity);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
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
              fontSize: Dimensions.fontSizeDefault,
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

