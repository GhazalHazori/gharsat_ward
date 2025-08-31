import 'package:flutter/material.dart';
import 'package:gharsat_ward/features/category/domain/models/category_model.dart';
import 'package:gharsat_ward/features/product/screens/brand_and_category_product_screen.dart';
import 'package:gharsat_ward/common/basewidget/custom_app_bar_widget.dart';
import 'package:gharsat_ward/common/basewidget/custom_image_widget.dart';
import 'package:gharsat_ward/features/product/screens/brand_and_product_category_shippin.dart';

class SubSubCategoryScreen extends StatelessWidget {
  final SubCategory subCategory;

  const SubSubCategoryScreen({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: subCategory.name ?? ''),
      body: subCategory.subSubCategories == null ||
              subCategory.subSubCategories!.isEmpty
          ? const Center(child: Text("لا يوجد فئات فرعية"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: subCategory.subSubCategories!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // عدد الأعمدة
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final subSub = subCategory.subSubCategories![index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BrandAndCategoryProductShippin(
                            isBrand: false,
                            id: subSub.id,
                            name: subSub.name,
                          ),
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
  image: subSub.imageFullUrl?.path ?? '',
  fit: BoxFit.cover,
),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subSub.name ?? '',
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
