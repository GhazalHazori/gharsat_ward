import 'package:flutter/material.dart';
import 'package:gharsat_ward/features/category/controllers/category_controller.dart';
import 'package:gharsat_ward/features/category/widgets/category_widget.dart';
import 'package:gharsat_ward/features/product/screens/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';

import '../../../features/category/widgets/category_shimmer_widget.dart';

// mr_edit
class CategoryGridWidget extends StatelessWidget {
  const CategoryGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        return categoryProvider.categoryList.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.all(12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.80,
                ),
                itemCount: categoryProvider.categoryList.length,
                itemBuilder: (context, index) {
                  final category = categoryProvider.categoryList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        
                        context,
                        MaterialPageRoute(
                          builder: (_) => BrandAndCategoryProductScreen(
                            isBrand: false,
                            id: category.id,
                            name: category.name,
                          ),
                        ),
                      );
                    },
                    child: CategoryWidget(
                        category: category,
                        index: index,
                        length: categoryProvider.categoryList.length),
                  );
                },
              )
            : const CategoryShimmerWidget();
      },
    );
  }
}
