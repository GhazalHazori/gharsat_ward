import 'package:flutter/material.dart';
import 'package:gharsat_ward/features/category/domain/models/category_model.dart';
import 'package:gharsat_ward/features/category/controllers/category_controller.dart';
import 'package:gharsat_ward/features/category_home/sub_category_screen.dart';
import 'package:gharsat_ward/features/product/screens/brand_and_category_product_screen.dart';
import 'package:gharsat_ward/features/product/screens/brand_and_product_category_shippin.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/common/basewidget/custom_app_bar_widget.dart';
import 'package:gharsat_ward/common/basewidget/custom_image_widget.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:provider/provider.dart';

// ✅ استيراد عناصر البحث
import 'package:gharsat_ward/features/search_product/screens/search_product_screen.dart';
import 'package:gharsat_ward/features/home/widgets/search_home_page_widget.dart';

class CategoryScreenHome extends StatelessWidget {
  const CategoryScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Consumer<CategoryController>(
        builder: (context, categoryProvider, child) {
          return categoryProvider.categoryList.isNotEmpty
              ? Column(
                  children: [
                    // ✅ شريط البحث
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        );
                      },
                      child: const Hero(
                        tag: 'search',
                        child: Material(
                          child: SizedBox(height: 70,
                            child: SearchHomePageWidget()),
                        ),
                      ),
                    ),

                    // ✅ شبكة الفئات
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: categoryProvider.categoryList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final category = categoryProvider.categoryList[index];
                          return InkWell(
                            onTap: () {
                              category.subCategories != null &&
                                      category.subCategories!.isNotEmpty
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SubCategoryScreen(category: category),
                                      ),
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BrandAndCategoryProductShippin(
                                          isBrand: false,
                                          id: category.id,
                                          name: category.name,
                                        ),
                                      ),
                                    );
                            },
                            child: CategoryItem(
                              title: category.name,
                              icon: category.imageFullUrl?.path,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String? title;
  final String? icon;

  const CategoryItem({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipOval(
            child: CustomImageWidget(image: icon ?? ''),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title ?? '',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textMedium.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
