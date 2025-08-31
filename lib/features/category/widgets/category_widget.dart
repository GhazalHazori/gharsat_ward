import 'package:flutter/material.dart';
import 'package:gharsat_ward/features/category/domain/models/category_model.dart';
import 'package:gharsat_ward/localization/controllers/localization_controller.dart';
import 'package:gharsat_ward/utill/color_resources.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';
// mr_edit
class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final int length;

  const CategoryWidget({
    super.key,
    required this.category,
    required this.index,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width / 4.2;

    return Padding(
      padding: EdgeInsets.only(
        left: Provider.of<LocalizationController>(context, listen: false).isLtr
            ? Dimensions.homePagePadding
            : 0,
        right: index + 1 == length
            ? Dimensions.paddingSizeDefault
            : Provider.of<LocalizationController>(context, listen: false).isLtr
                ? 0
                : Dimensions.homePagePadding,
      ),
      child: Column(
        children: [
          Container(
            height: imageSize,
            width: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withValues(alpha: .1),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: .2),
                width: 0.5,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                image: '${category.imageFullUrl?.path}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          SizedBox(
            width: imageSize,
            child: Text(
              category.name ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: ColorResources.getTextTitle(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
