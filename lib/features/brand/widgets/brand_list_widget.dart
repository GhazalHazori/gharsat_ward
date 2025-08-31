import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/paginated_list_view_widget.dart';
import 'package:gharsat_ward/features/brand/controllers/brand_controller.dart';
import 'package:gharsat_ward/features/brand/widgets/brand_shimmer_widget.dart';
import 'package:gharsat_ward/features/product/screens/brand_and_category_product_screen.dart';
import 'package:gharsat_ward/helper/responsive_helper.dart';
import 'package:gharsat_ward/localization/controllers/localization_controller.dart';
import 'package:gharsat_ward/theme/controllers/theme_controller.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';

class BrandListWidget extends StatefulWidget {
  final bool isHomePage;
  const BrandListWidget({super.key, required this.isHomePage});

  @override
  State<BrandListWidget> createState() => _BrandListWidgetState();
}

class _BrandListWidgetState extends State<BrandListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandController>(
      builder: (context, brandProvider, child) {
        return brandProvider.brandList.isNotEmpty
            ? widget.isHomePage
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                 
                    child: Row(
                        children: brandProvider.brandList
                            .map((brand) => InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                BrandAndCategoryProductScreen(
                                                    isBrand: true,
                                                    id: brand.id,
                                                    name: brand.name,
                                                    image: brand
                                                        .imageFullUrl?.path)));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            Provider.of<LocalizationController>(
                                                        context,
                                                        listen: false)
                                                    .isLtr
                                                ? Dimensions.paddingSizeSmall
                                                : 0,
                                        right: brandProvider.brandList.length ==
                                                brandProvider.brandList
                                                        .indexOf(brand) +
                                                    1
                                            ? Dimensions.paddingSizeDefault
                                            : Provider.of<LocalizationController>(
                                                        context,
                                                        listen: false)
                                                    .isLtr
                                                ? 0
                                                : Dimensions
                                                    .paddingSizeDefault),
                                    child: Container( margin: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container( 
                                            width: ResponsiveHelper.isTab(context)
                                                ? 120
                                                : 50,
                                            height:
                                                ResponsiveHelper.isTab(context)
                                                    ? 120
                                                    : 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                color: Theme.of(context)
                                                    .highlightColor,
                                                boxShadow:
                                                    Provider.of<ThemeController>(
                                                                context,
                                                                listen: false)
                                                            .darkTheme
                                                        ? null
                                                        : [
                                                            BoxShadow(
                                                                color: Colors.grey
                                                                    .withValues(
                                                                        alpha:
                                                                            0.12),
                                                                spreadRadius: 1,
                                                                blurRadius: 1,
                                                                offset:
                                                                    const Offset(
                                                                        0, 1))
                                                          ]),
                                            child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                child: CustomImageWidget(
                                                    image:
                                                        '${brand.imageFullUrl?.path!}')),
                                          ),
                                          SizedBox(height:   Dimensions.paddingSizeSmall,),
                                          Text("${brand.name}",style: textMedium.copyWith(fontSize: 10),     textAlign: TextAlign.center,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList()))
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: PaginatedListView(
                        scrollController: _scrollController,
                        totalSize: brandProvider.brandModel?.totalSize,
                        offset: brandProvider.brandModel?.offset,
                        onPaginate: (int? offset) async {
                          await brandProvider.getBrandList(false,
                              offset: offset!);
                        },
                        itemView: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: (1 / 1.3),
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 5),
                          padding: EdgeInsets.zero,
                          itemCount: brandProvider.brandList.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            BrandAndCategoryProductScreen(
                                                isBrand: true,
                                                id: brandProvider
                                                    .brandList[index].id,
                                                name: brandProvider
                                                    .brandList[index].name,
                                                image: brandProvider
                                                    .brandList[index]
                                                    .imageFullUrl
                                                    ?.path)));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.paddingSizeSmall),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.paddingSizeSmall)),
                                      child: CustomImageWidget(
                                          image:
                                              '${brandProvider.brandList[index].imageFullUrl?.path!}'),
                                    ),
                                  )),
                                  SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.width /
                                                  4) *
                                              0.3,
                                      child: Center(
                                          child: Text(
                                              brandProvider
                                                  .brandList[index].name!,
                                              maxLines: 1,
                                              
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: textRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeSmall)))),
                                ],
                              ),
                            );
                          },
                        )),
                  )
            : BrandShimmerWidget(isHomePage: widget.isHomePage);
      },
    );
  }
}
