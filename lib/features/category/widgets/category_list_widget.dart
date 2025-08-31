import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/title_row_widget.dart';
import 'package:gharsat_ward/features/category/controllers/category_controller.dart';
import 'package:gharsat_ward/features/category/screens/category_screen.dart';
import 'package:gharsat_ward/features/category/widgets/category_widget.dart';
import 'package:gharsat_ward/features/product/screens/brand_and_category_product_screen.dart';
import 'package:gharsat_ward/localization/controllers/localization_controller.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:provider/provider.dart';

import 'category_shimmer_widget.dart';

class CategoryListWidget extends StatelessWidget {
  final bool isHomePage;
  const CategoryListWidget({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraExtraSmall),
            child: TitleRowWidget(
              title: getTranslated('CATEGORY', context),
              onTap: () {
                if (categoryProvider.categoryList.isNotEmpty) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CategoryScreen()));
                }
              },
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          categoryProvider.categoryList.isNotEmpty
              ? SizedBox(
                  height: Provider.of<LocalizationController>(context,
                              listen: false)
                          .isLtr
                      ? MediaQuery.of(context).size.width / 3.7
                      : MediaQuery.of(context).size.width / 3,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryProvider.categoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BrandAndCategoryProductScreen(
                                      isBrand: false,
                                      id: categoryProvider
                                          .categoryList[index].id,
                                      name: categoryProvider
                                          .categoryList[index].name)));
                        },
                        child: CategoryWidget(
                            category: categoryProvider.categoryList[index],
                            index: index,
                            length: categoryProvider.categoryList.length),
                      );
                    },
                  ),
                )
              : const CategoryShimmerWidget(),
        ]);
      },
    );
  }
}
