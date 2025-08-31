import 'package:flutter/material.dart';
import 'package:gharsat_ward/features/category/domain/models/category_model.dart';
import 'package:gharsat_ward/utill/color_resources.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/common/basewidget/custom_image_widget.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / 5;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              image: '${category.imageFullUrl?.path}',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        SizedBox(
          width: size,
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
    );
  }
}
