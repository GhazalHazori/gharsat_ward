import 'package:flutter/material.dart';
import 'package:gharsat_ward/features/cart/controllers/cart_controller.dart';
import 'package:gharsat_ward/helper/responsive_helper.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/utill/color_resources.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:provider/provider.dart';

class CustomMenuWidget extends StatelessWidget {
  final bool isSelected;
  final String name;
  final String icon;
  final bool showCartCount;
  final VoidCallback onTap;

  const CustomMenuWidget({
    super.key,
    required this.isSelected,
    required this.name,
    required this.icon,
    required this.onTap,
    this.showCartCount = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InkWell(
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.001,
            horizontal: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Image.asset(
                    icon,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).hintColor,
                    width: MediaQuery.of(context).size.width * 0.07,
                    height: MediaQuery.of(context).size.width * 0.07,
                  ),
                  if (showCartCount)
                    Positioned(
                      top: -1,
                      right: -1,
                      child: Consumer<CartController>(
                          builder: (context, cart, child) {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: ColorResources.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 17,
                            minHeight: 17,
                          ),
                          child: Text(
                            cart.cartList.length.toString(),
                            style: titilliumSemiBold.copyWith(
                              color: ColorResources.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                getTranslated(name, context)!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: isSelected
                    ? textBold.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                      )
                    : textMedium.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: 11,
                      ),
              ),
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 4,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
