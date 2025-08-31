import 'package:flutter/material.dart';
import 'package:gharsat_ward/helper/price_converter.dart';
import 'package:gharsat_ward/localization/controllers/localization_controller.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/features/product/domain/models/product_model.dart';
import 'package:provider/provider.dart';

class DiscountTagWidget extends StatelessWidget {
  const DiscountTagWidget({
    super.key,
    required this.productModel,
    this.positionedTop = 10,
    this.positionedLeft = 0,
    this.positionedRight = 0,
  });

  final Product productModel;
  final double positionedTop;
  final double positionedLeft;
  final double positionedRight;

  @override
  Widget build(BuildContext context) {
    final bool isLtr =
        Provider.of<LocalizationController>(context, listen: false).isLtr;

    return Positioned(
        top: positionedTop,
        left: isLtr ? positionedLeft : null,
        right: !isLtr ? positionedRight : null,
        child: Container(
            transform: Matrix4.translationValues(-1, 0, 0),
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall, vertical: 3),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(
                        isLtr ? Dimensions.paddingSizeExtraLarge : 0),
                    topRight: Radius.circular(
                        isLtr ? Dimensions.paddingSizeExtraLarge : 0),
                    bottomLeft: Radius.circular(
                        isLtr ? 0 : Dimensions.paddingSizeExtraLarge),
                    topLeft: Radius.circular(
                        isLtr ? 0 : Dimensions.paddingSizeExtraLarge))),
            child: Center(
                child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                productModel.clearanceSale != null
                    ? "Deal"
                    : "Deal",
                style: textBold.copyWith(
                    color: Colors.white, fontSize: 6),
                textAlign: TextAlign.center,
              ),
            ))));
  }
}
