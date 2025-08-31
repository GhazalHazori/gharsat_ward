import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/features/banner/controllers/banner_controller.dart';
import 'package:gharsat_ward/features/banner/widgets/banner_shimmer.dart';
import 'package:gharsat_ward/theme/controllers/theme_controller.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';

class BannersWidget extends StatelessWidget {
  const BannersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        children: [
          Consumer<BannerController>(
            builder: (context, bannerProvider, child) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              return Stack(
                children: [
                  bannerProvider.mainBannerList != null
                      ? bannerProvider.mainBannerList!.isNotEmpty
                          ? SizedBox(
                              height: height * .27,
                              width: width,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * .25,
                                    width: width,
                                    child: CarouselSlider.builder(
                                      options: CarouselOptions(
                                          aspectRatio: 4 / 1,
                                          viewportFraction: 1.0,
                                          autoPlay: true,
                                          pauseAutoPlayOnTouch: true,
                                          pauseAutoPlayOnManualNavigate: true,
                                          pauseAutoPlayInFiniteScroll: true,
                                          enlargeFactor: .2,
                                          enlargeCenterPage: true,
                                          disableCenter: true,
                                          onPageChanged: (index, reason) {
                                            Provider.of<BannerController>(
                                                    context,
                                                    listen: false)
                                                .setCurrentIndex(index);
                                          }),
                                      itemCount:
                                          bannerProvider.mainBannerList!.isEmpty
                                              ? 1
                                              : bannerProvider
                                                  .mainBannerList?.length,
                                      itemBuilder: (context, index, _) {
                                        return InkWell(
                                          onTap: () {
                                            if (bannerProvider
                                                    .mainBannerList![index]
                                                    .resourceId !=
                                                null) {
                                              bannerProvider.clickBannerRedirect(
                                                  context,
                                                  bannerProvider
                                                      .mainBannerList![index]
                                                      .resourceId,
                                                  bannerProvider
                                                              .mainBannerList![
                                                                  index]
                                                              .resourceType ==
                                                          'product'
                                                      ? bannerProvider
                                                          .mainBannerList![
                                                              index]
                                                          .product
                                                      : null,
                                                  bannerProvider
                                                      .mainBannerList![index]
                                                      .resourceType);
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.paddingSizeSmall),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        Dimensions
                                                            .paddingSizeSmall),
                                                    color: Provider.of<ThemeController>(
                                                                context,
                                                                listen: false)
                                                            .darkTheme
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                            .withValues(
                                                                alpha: .1)
                                                        : Theme.of(context)
                                                            .primaryColor
                                                            .withValues(
                                                                alpha: .05)),
                                                child: CustomImageWidget(
                                                    image: '${bannerProvider.mainBannerList?[index].photoFullUrl?.path}')),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox()
                      : const BannerShimmer(),
                  if (bannerProvider.mainBannerList != null &&
                      bannerProvider.mainBannerList!.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: bannerProvider.mainBannerList!
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          bool isActive = index == bannerProvider.currentIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            height: 7,
                            width: isActive ? 40 : 7,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
