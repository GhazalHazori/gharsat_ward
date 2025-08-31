import 'package:flutter/material.dart';
import 'package:gharsat_ward/features/category/domain/models/category_model.dart';
import 'package:gharsat_ward/common/basewidget/custom_app_bar_widget.dart';
import 'package:gharsat_ward/features/category_home/sub_sub_category.dart';
import 'package:gharsat_ward/common/basewidget/custom_image_widget.dart';
import 'package:gharsat_ward/features/product/screens/brand_and_category_product_screen.dart';
import 'package:gharsat_ward/features/product/screens/brand_and_product_category_shippin.dart';

class SubCategoryScreen extends StatelessWidget {
  final CategoryModel category;

  const SubCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: category.name),
      body: category.subCategories == null || category.subCategories!.isEmpty
          ? const Center(child: Text("لا يوجد فئات فرعية"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: category.subCategories!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // عدد الأعمدة
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final subCategory = category.subCategories![index];
                  return InkWell(
                    onTap: () {
                      category.subCategories![index].subSubCategories!.isEmpty?     Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BrandAndCategoryProductShippin(
                          isBrand: false,
                          id: subCategory.id,
                          name: subCategory.name,
                        ))
                        ):
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SubSubCategoryScreen(subCategory: subCategory),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipOval(
                          child: CustomImageWidget(
  image: subCategory.imageFullUrl?.path ?? '',
  fit: BoxFit.cover,
),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subCategory.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
