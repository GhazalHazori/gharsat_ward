import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/title_row_widget.dart';
import 'package:gharsat_ward/features/address/controllers/address_controller.dart';
import 'package:gharsat_ward/features/auth/controllers/auth_controller.dart';
import 'package:gharsat_ward/features/banner/controllers/banner_controller.dart';
import 'package:gharsat_ward/features/banner/widgets/banners_widget.dart';
import 'package:gharsat_ward/features/banner/widgets/footer_banner_slider_widget.dart';
import 'package:gharsat_ward/features/banner/widgets/single_banner_widget.dart';
import 'package:gharsat_ward/features/brand/controllers/brand_controller.dart';
import 'package:gharsat_ward/features/brand/screens/brands_screen.dart';
import 'package:gharsat_ward/features/brand/widgets/brand_list_widget.dart';
import 'package:gharsat_ward/features/cart/controllers/cart_controller.dart';
import 'package:gharsat_ward/features/category/controllers/category_controller.dart';
import 'package:gharsat_ward/features/clearance_sale/widgets/clearance_sale_list_widget.dart';
import 'package:gharsat_ward/features/deal/controllers/featured_deal_controller.dart';
import 'package:gharsat_ward/features/deal/controllers/flash_deal_controller.dart';
import 'package:gharsat_ward/features/deal/screens/featured_deal_screen_view.dart';
import 'package:gharsat_ward/features/deal/screens/flash_deal_screen_view.dart';
import 'package:gharsat_ward/features/deal/widgets/featured_deal_list_widget.dart';
import 'package:gharsat_ward/features/deal/widgets/flash_deals_list_widget.dart';
import 'package:gharsat_ward/features/deals/screen/deal_screen.dart';
import 'package:gharsat_ward/features/home/shimmers/flash_deal_shimmer.dart';
import 'package:gharsat_ward/features/home/widgets/announcement_widget.dart';
import 'package:gharsat_ward/features/home/widgets/aster_theme/find_what_you_need_shimmer.dart';
import 'package:gharsat_ward/features/home/widgets/featured_product_widget.dart';
import 'package:gharsat_ward/features/home/widgets/search_home_page_widget.dart';
import 'package:gharsat_ward/features/notification/controllers/notification_controller.dart';
import 'package:gharsat_ward/features/product/controllers/product_controller.dart';
import 'package:gharsat_ward/features/product/domain/models/product_model.dart';
import 'package:gharsat_ward/features/product/enums/product_type.dart';
import 'package:gharsat_ward/features/product/widgets/home_category_product_widget.dart';
import 'package:gharsat_ward/features/product/widgets/latest_product_list_widget.dart';
import 'package:gharsat_ward/features/product/widgets/products_list_widget.dart';
import 'package:gharsat_ward/features/product/widgets/recommended_product_widget.dart';
import 'package:gharsat_ward/features/profile/controllers/profile_contrroller.dart';
import 'package:gharsat_ward/features/search_product/screens/search_product_screen.dart';
import 'package:gharsat_ward/features/shop/controllers/shop_controller.dart';
import 'package:gharsat_ward/features/shop/screens/all_shop_screen.dart';
import 'package:gharsat_ward/features/shop/widgets/top_seller_view.dart';
import 'package:gharsat_ward/features/splash/controllers/splash_controller.dart';
import 'package:gharsat_ward/features/splash/domain/models/config_model.dart';
import 'package:gharsat_ward/features/wallet/controllers/wallet_controller.dart';
import 'package:gharsat_ward/helper/responsive_helper.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/theme/controllers/theme_controller.dart';
import 'package:gharsat_ward/utill/color_resources.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/utill/images.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utill/app_constants.dart';
import '../../cities/city_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static Future<void> loadData(bool reload) async {
    final flashDealController =
    Provider.of<FlashDealController>(Get.context!, listen: false);
    final shopController =
    Provider.of<ShopController>(Get.context!, listen: false);
    final categoryController =
    Provider.of<CategoryController>(Get.context!, listen: false);
    final bannerController =
    Provider.of<BannerController>(Get.context!, listen: false);
    final addressController =
    Provider.of<AddressController>(Get.context!, listen: false);
    final productController =
    Provider.of<ProductController>(Get.context!, listen: false);
    final brandController =
    Provider.of<BrandController>(Get.context!, listen: false);
    final featuredDealController =
    Provider.of<FeaturedDealController>(Get.context!, listen: false);
    final notificationController =
    Provider.of<NotificationController>(Get.context!, listen: false);
    final cartController =
    Provider.of<CartController>(Get.context!, listen: false);
    final profileController =
    Provider.of<ProfileController>(Get.context!, listen: false);
    final splashController =
    Provider.of<SplashController>(Get.context!, listen: false);
    final walletController =
    Provider.of<WalletController>(Get.context!, listen: false);
    //  final profileCtrl = Provider.of<ProfileController>(Get.context!, listen: false);

    if (flashDealController.flashDealList.isEmpty || reload) {
      await flashDealController.getFlashDealList(reload, false);
    }

    splashController.initConfig(Get.context!, null, null);

    categoryController.getCategoryList(reload);

    bannerController.getBannerList(reload);

    shopController.getTopSellerList(reload, 1, type: "top");

    shopController.getAllSellerList(reload, 1, type: "all");
    walletController.getOldestUnpaidTransactions(offset: 1,oldestUnpaid: 1);

    if (addressController.addressList == null ||
        (addressController.addressList != null &&
            addressController.addressList!.isEmpty) ||
        reload) {
      addressController.getAddressList();
    }

    cartController.getCartData(Get.context!);

    productController.getHomeCategoryProductList(reload);

    brandController.getBrandList(reload);

    featuredDealController.getFeaturedDealList(reload);

    productController.getLProductList('1', reload: reload);

    productController.getLatestProductList(1, reload: reload);

    productController.getFeaturedProductList('1', reload: reload);

    productController.getRecommendedProduct();

    productController.getClearanceAllProductList('1');
    walletController.getOldestUnpaidTransactions(offset: 1,oldestUnpaid: 1);
    if (notificationController.notificationModel == null ||
        (notificationController.notificationModel != null &&
            notificationController.notificationModel!.notification!.isEmpty) ||
        reload) {
      notificationController.getNotificationList(1);
    }

    if (Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn() &&
        profileController.userInfoModel == null) {
      profileController.getUserInfo(Get.context!);
    }
  }
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  void passData(int index, String title) {
    index = index;
    title = title;
  }

  bool singleVendor = false;
  // mr_edit
  late CityController cityController;

  int selectedTab = 0;
  String cityid="";
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashController>(context, listen: false)
        .configModel!
        .businessMode ==
        "single";      cityid=Provider.of<ProfileController>(context, listen: false).userInfoModel?.cityId??'';
    // final profileCtrl = Provider.of<ProfileController>(Get.context!, listen: false);


    // Set initial shipping method to 1 since selectedTab starts at 0 (Express)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductController>(context, listen: false)
          .changeShippingMethod(1);
      Provider.of<FlashDealController>(context, listen: false)
          .changeShippingMethod(1);
      Provider.of<FeaturedDealController>(context, listen: false)
          .changeShippingMethod(1);
    });
    Provider.of<AuthController>(Get.context!,
        listen: false)
        .getUserToken() !=
        ""
        ?
    Future.microtask(() {

      Provider.of<WalletController>(context, listen: false)
          .getOldestUnpaidTransactions(offset: 1,oldestUnpaid: 1);
    }):null;
    // mr_edit
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   cityController = Provider.of<CityController>(context, listen: false);
    //   cityController.fetchCities();
    //   final prefs = await SharedPreferences.getInstance();
    //   if (prefs.getInt(AppConstants.choosenCity) != null) {
    //     _showCitySelectionDialog(context, cityController);
    //   }
    // });
  }

  // void _showCitySelectionDialog(
  //     BuildContext context, CityController cityController) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Select your city'),
  //       content: SizedBox(
  //         width: double.maxFinite,
  //         child: Consumer<CityController>(
  //             builder: (context, cityController, child) {
  //           return cityController.isLoadingCity
  //               ? const Center(child: CircularProgressIndicator())
  //               : ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: cityController.cities.length,
  //                   itemBuilder: (context, index) {
  //                     final city = cityController.cities[index];
  //                     return ListTile(
  //                       title: Text(city.name),
  //                       onTap: () {
  //                         cityController.changeCity(city);
  //                         Navigator.pop(context);
  //                       },
  //                     );
  //                   },
  //                 );
  //         }),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel =
        Provider.of<SplashController>(context, listen: false).configModel;

    List<String?> types = [
      getTranslated('new_arrival', context),
      getTranslated('top_product', context),
      getTranslated('best_selling', context),
      getTranslated('discounted_product', context)
    ];
    // final profileCtrl = Provider.of<ProfileController>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await HomePage.loadData(true);
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                  child: Provider.of<SplashController>(context, listen: false)
                      .configModel!
                      .announcement!
                      .status ==
                      '1'
                      ? Consumer<SplashController>(
                      builder: (context, announcement, _) {
                        return (announcement.configModel!.announcement!
                            .announcement !=
                            null &&
                            announcement.onOff)
                            ? AnnouncementWidget(
                            announcement:
                            announcement.configModel!.announcement)
                            : const SizedBox();
                      })
                      : const SizedBox()),

              // التبويبات

              SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SearchScreen())),
                      child: const Hero(
                          tag: 'search',
                          child: Material(child: SearchHomePageWidget())),
                    ),
                  )),

              SliverToBoxAdapter(
                  child: Provider.of<AuthController>(Get.context!,
                      listen: false)
                      .getUserToken() !=
                      ""
                      ? Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(
                              0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color: Colors.orange.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('${getTranslated('order_total', context)!}',
                                      style: textBold.copyWith(
                                        color: ColorResources.black,
                                        fontSize: 10,
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Consumer<CartController>(
                                      builder: (context, cart, child) {
                                        return Text(
                                            cart.cartList.length.toString(),
                                            style: textBold.copyWith(
                                              color: ColorResources.black,
                                              fontSize: 10,
                                            ));
                                      }),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${getTranslated('credit_limit', context)!}',
                                    style: textBold.copyWith(
                                      color: ColorResources.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Consumer<WalletController>(
                                      builder: (context, cart, child) {

                                        String datedue = cart.walletTransactionModel?.walletTransactionList == null || cart.walletTransactionModel!.walletTransactionList!.isEmpty
                                            ? getTranslated('date_due', context)!
                                            : (() {

                                          DateTime createdAt = DateTime.parse(
                                              cart.walletTransactionModel!.walletTransactionList!.last.createdAt!);

                                          DateTime dueDate = createdAt.add(Duration(days: 15));

                                          return DateFormat('yyyy-MM-dd').format(dueDate);
                                        })();

                                        return Row(
                                          children: [
                                            Text(
                                                datedue,
                                                style: textBold.copyWith(
                                                  color: ColorResources.black,
                                                  fontSize: 10,
                                                )),
                                            //  cart.walletTransactionModel!= null ?             Image.asset(Images.saudiImage,color: Colors.black,width: 15,):SizedBox()

                                          ],
                                        );
                                      }),
                                ],
                              ),

                              //  Text( ' المتبقي: '),
                              // Text(
                              // '46,797.52',
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.blue.shade600,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Consumer<ProfileController>(
                            builder: (context, profileProvider, _) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 2),
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 223, 226, 228),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    Text(
                                      "${getTranslated('creditt', context)!}\n${profileProvider.balance??''}",
                                      style: textBold.copyWith(
                                        color: const Color.fromARGB(
                                            255, 210, 139, 33),
                                        fontSize: 12,
                                      ),
                                    ),  Image.asset(Images.saudiImage,color: Colors.black,width: 15,)
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  )
                      : SizedBox()),

              SliverToBoxAdapter(
                  child: Provider.of<AuthController>(Get.context!,
                      listen: false)
                      .getUserToken() ==
                      ""
                      ?SizedBox():
                  Provider.of<ProfileController>(context, listen: true).userInfoModel==null?
                  Center(child: CircularProgressIndicator()):
                  Center(
                      child: SizedBox(
                          width:
                          ResponsiveHelper.isDesktop(context) ? 800 : null,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault),
                              child: Stack(children: [
                                // الخط الأساسي (الخلفي)
                                Container(
                                  height:
                                  40, // نفس ارتفاع الـ Containers الداخلية + margin
                                  decoration: BoxDecoration(
                                      color:    Provider.of<ProfileController>(context, listen: true).userInfoModel?.cityId !="2"? Color.fromARGB(255, 255, 218, 164):Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                Center(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex:  Provider.of<ProfileController>(context, listen: true).userInfoModel?.cityId =="2"?80:1,
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() {
                                              selectedTab = 0;
                                            });
                                            Provider.of<ProductController>(
                                                context,
                                                listen: false)
                                                .changeShippingMethod(
                                                1); // Express shipping
                                            Provider.of<FlashDealController>(
                                                context,
                                                listen: false)
                                                .changeShippingMethod(1);
                                            Provider.of<FeaturedDealController>(
                                                context,
                                                listen: false)
                                                .changeShippingMethod(1);
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: selectedTab == 0
                                                    ? const Color.fromARGB(
                                                    255, 210, 139, 33)
                                                    : Colors.transparent,
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child: Center(
                                              child: Text(
                                                getTranslated(
                                                    'express', context) ??
                                                    '',
                                                style: textMedium.copyWith(
                                                  color: selectedTab == 0
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() {
                                              selectedTab = 1;
                                            });
                                            Provider.of<ProductController>(
                                                context,
                                                listen: false)
                                                .changeShippingMethod(
                                                2); // Pre-order shipping
                                            Provider.of<FlashDealController>(
                                                context,
                                                listen: false)
                                                .changeShippingMethod(2);
                                            Provider.of<FeaturedDealController>(
                                                context,
                                                listen: false)
                                                .changeShippingMethod(2);
                                          },
                                          child: Visibility(visible: Provider.of<ProfileController>(context, listen: true).userInfoModel?.cityId !="2",
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: selectedTab == 1
                                                      ? const Color.fromARGB(
                                                      255, 210, 139, 33)
                                                      : Colors.transparent,
                                                  borderRadius:
                                                  BorderRadius.circular(10)),
                                              child: Center(
                                                child: Text(
                                                  getTranslated(
                                                      'pre_order', context) ??
                                                      '',
                                                  style: textMedium.copyWith(
                                                    color: selectedTab == 1
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]))
                      ))
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    const BannersWidget(),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Consumer<FlashDealController>(
                        builder: (context, megaDeal, child) {
                          print('FlashDeal: ${megaDeal.flashDeal}');
                          print(
                              'FlashDealList length: ${megaDeal.flashDealList.length}');
                          return megaDeal.flashDeal == null
                              ? const FlashDealShimmer()
                              : megaDeal.flashDealList.isNotEmpty
                              ? Column(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                  Dimensions.paddingSizeDefault),
                              child: TitleRowWidget(
                                title:
                                getTranslated('flash_deal', context)
                                    ?.toUpperCase(),
                                eventDuration: megaDeal.flashDeal != null
                                    ? megaDeal.duration
                                    : null,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                          const FlashDealScreenView()));
                                },
                                isFlash: true,
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeSmall),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                  Dimensions.paddingSizeDefault),
                              child: Text(
                                getTranslated(
                                    'hurry_up_the_offer_is_limited_grab_while_it_lasts',
                                    context) ??
                                    '',
                                style: textRegular.copyWith(
                                    color: Provider.of<ThemeController>(
                                        context,
                                        listen: false)
                                        .darkTheme
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSizeDefault),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeSmall),
                            const FlashDealsListWidget()
                          ])
                              : const SizedBox.shrink();
                        }),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Consumer<FeaturedDealController>(
                        builder: (context, featuredDealProvider, child) {
                          return featuredDealProvider.featuredDealProductList !=
                              null
                              ? featuredDealProvider
                              .featuredDealProductList!.isNotEmpty
                              ? Column(
                            children: [
                              Stack(children: [
                                Container(
                                  width: 50,
                                  height: 80,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiary,
                                ),
                                Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions
                                            .paddingSizeExtraSmall),
                                    child: TitleRowWidget(
                                      title:
                                      '${getTranslated('featured_deals', context)}',
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                              const FeaturedDealScreenView())),
                                    ),
                                  ),
                                  const FeaturedDealsListWidget(),
                                ]),
                              ]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraExtraSmall),
                            ],
                          )
                              : const SizedBox.shrink()
                              : const FindWhatYouNeedShimmer();
                        }),
                    const ClearanceListWidget(),
                    const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
                    Consumer<BannerController>(
                        builder: (context, footerBannerProvider, child) {
                          return footerBannerProvider.footerBannerList != null &&
                              footerBannerProvider.footerBannerList!.isNotEmpty
                              ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault),
                              child: SingleBannersWidget(
                                  bannerModel: footerBannerProvider
                                      .footerBannerList?[0]))
                              : const SizedBox();
                        }),
                    // const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
                    Consumer<ProductController>(
                        builder: (context, productController, _) {
                          return productController.featuredProductList!=null? FeaturedProductWidget():SizedBox();
                        }),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    singleVendor
                        ? const SizedBox()
                        : Consumer<ShopController>(
                        builder: (context, topSellerProvider, child) {
                          return (topSellerProvider.sellerModel != null &&
                              (topSellerProvider.sellerModel!.sellers !=
                                  null &&
                                  topSellerProvider
                                      .sellerModel!.sellers!.isNotEmpty))
                              ? TitleRowWidget(
                              title: getTranslated('top_seller', context),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                      const AllTopSellerScreen(
                                        title: 'top_stores',
                                      ))))
                              : const SizedBox();
                        }),
                    singleVendor
                        ? const SizedBox(height: 0)
                        : const SizedBox(height: Dimensions.paddingSizeSmall),
                    singleVendor
                        ? const SizedBox()
                        : Consumer<ShopController>(
                        builder: (context, topSellerProvider, child) {
                          return (topSellerProvider.sellerModel != null &&
                              (topSellerProvider.sellerModel!.sellers !=
                                  null &&
                                  topSellerProvider
                                      .sellerModel!.sellers!.isNotEmpty))
                              ? Padding(
                              padding: const EdgeInsets.only(
                                  bottom: Dimensions.paddingSizeDefault),
                              child: SizedBox(
                                  height: ResponsiveHelper.isTab(context)
                                      ? 170
                                      : 165,
                                  child: TopSellerView(
                                    isHomePage: true,
                                    scrollController: _scrollController,
                                  )))
                              : const SizedBox();
                        }),
                    Padding(
                        padding: const EdgeInsets.only(
                            bottom: Dimensions.paddingSizeDefault),
                        child: Consumer<ProductController>(
                          builder: (context, productController, child) {
                            print(
                                'RecommendedProduct: ${productController.recommendedProduct}');
                            return productController.recommendedProduct!=null?  RecommendedProductWidget():SizedBox();
                          },
                        ))
                    ,
                    const Padding(
                        padding: EdgeInsets.only(
                            bottom: Dimensions.paddingSizeDefault),
                        child: LatestProductListWidget()),
                    if (configModel?.brandSetting == "1")
                      TitleRowWidget(
                        title: getTranslated('brand', context),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const BrandsView())),
                      ),
                    SizedBox(
                        height: configModel?.brandSetting == "1"
                            ? Dimensions.paddingSizeSmall
                            : 0),
                    if (configModel!.brandSetting == "1") ...[
                      const BrandListWidget(isHomePage: true),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ],
                    const HomeCategoryProductWidget(isHomePage: true),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    const FooterBannerSliderWidget(),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Consumer<ProductController>(
                        builder: (ctx, prodProvider, child) {
                          return Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            Dimensions.paddingSizeDefault,
                                            0,
                                            Dimensions.paddingSizeSmall,
                                            0),
                                        child: Row(children: [
                                          Expanded(
                                              child: Text(
                                                  prodProvider.title == 'xyz'
                                                      ? getTranslated(
                                                      'new_arrival', context)!
                                                      : prodProvider.title!,
                                                  style: titleHeader)),
                                          prodProvider.latestProductList != null
                                              ? PopupMenuButton(
                                            padding: const EdgeInsets.all(0),
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  value:
                                                  ProductType.newArrival,
                                                  child: Text(
                                                      getTranslated(
                                                          'new_arrival',
                                                          context) ??
                                                          '',
                                                      style: textRegular
                                                          .copyWith(
                                                        color: prodProvider
                                                            .productType ==
                                                            ProductType
                                                                .newArrival
                                                            ? Theme.of(
                                                            context)
                                                            .primaryColor
                                                            : Theme.of(
                                                            context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                      )),
                                                ),
                                                PopupMenuItem(
                                                  value:
                                                  ProductType.topProduct,
                                                  child: Text(
                                                      getTranslated(
                                                          'top_product',
                                                          context) ??
                                                          '',
                                                      style: textRegular
                                                          .copyWith(
                                                        color: prodProvider
                                                            .productType ==
                                                            ProductType
                                                                .topProduct
                                                            ? Theme.of(
                                                            context)
                                                            .primaryColor
                                                            : Theme.of(
                                                            context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                      )),
                                                ),
                                                PopupMenuItem(
                                                  value:
                                                  ProductType.bestSelling,
                                                  child: Text(
                                                      getTranslated(
                                                          'best_selling',
                                                          context) ??
                                                          '',
                                                      style: textRegular
                                                          .copyWith(
                                                        color: prodProvider
                                                            .productType ==
                                                            ProductType
                                                                .bestSelling
                                                            ? Theme.of(
                                                            context)
                                                            .primaryColor
                                                            : Theme.of(
                                                            context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                      )),
                                                ),
                                                PopupMenuItem(
                                                  value: ProductType
                                                      .discountedProduct,
                                                  child: Text(
                                                      getTranslated(
                                                          'discounted_product',
                                                          context) ??
                                                          '',
                                                      style: textRegular
                                                          .copyWith(
                                                        color: prodProvider
                                                            .productType ==
                                                            ProductType
                                                                .discountedProduct
                                                            ? Theme.of(
                                                            context)
                                                            .primaryColor
                                                            : Theme.of(
                                                            context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                      )),
                                                ),
                                              ];
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(Dimensions
                                                    .paddingSizeSmall)),
                                            child: Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    Dimensions
                                                        .paddingSizeExtraSmall,
                                                    Dimensions
                                                        .paddingSizeSmall,
                                                    Dimensions
                                                        .paddingSizeExtraSmall,
                                                    Dimensions
                                                        .paddingSizeSmall),
                                                child: Image.asset(
                                                    Images.dropdown,
                                                    scale: 3)),
                                            onSelected: (ProductType value) {
                                              if (value ==
                                                  ProductType.newArrival) {
                                                Provider.of<ProductController>(
                                                    context,
                                                    listen: false)
                                                    .changeTypeOfProduct(
                                                    value, types[0]);
                                              } else if (value ==
                                                  ProductType.topProduct) {
                                                Provider.of<ProductController>(
                                                    context,
                                                    listen: false)
                                                    .changeTypeOfProduct(
                                                    value, types[1]);
                                              } else if (value ==
                                                  ProductType.bestSelling) {
                                                Provider.of<ProductController>(
                                                    context,
                                                    listen: false)
                                                    .changeTypeOfProduct(
                                                    value, types[2]);
                                              } else if (value ==
                                                  ProductType
                                                      .discountedProduct) {
                                                Provider.of<ProductController>(
                                                    context,
                                                    listen: false)
                                                    .changeTypeOfProduct(
                                                    value, types[3]);
                                              }
                                              //  Provider.of<ProductController>(context, listen: false).getLatestProductList(1, reload: true);
                                            },
                                          )
                                              : const SizedBox()
                                        ])),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                            Dimensions.paddingSizeSmall),
                                        child: ProductListWidget(
                                            isHomePage: false,
                                            productType: ProductType.newArrival,
                                            scrollController: _scrollController)),
                                    const SizedBox(
                                        height: Dimensions.homePagePadding)
                                  ]));
                        }),
                    //                 InkWell(
                    //          onTap: (){
                    // Navigator.push(
                    //         context,
                    //         PageRouteBuilder(
                    //             transitionDuration: const Duration(milliseconds: 1000),
                    //             pageBuilder: (context, anim1, anim2) => DiscountedProductListWidget(isHomePage: false,
                    //             )));
                    //          },child:  Icon(Icons.disc_full))

                    // Shop By Store Section - في النهاية
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    // Center(
                    //   child: Text(
                    //     'Shop By Store',
                    //     style: robotoBold.copyWith(
                    //       fontSize: Dimensions.fontSizeExtraLarge,
                    //       color: Theme.of(context).textTheme.bodyLarge?.color,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: Dimensions.paddingSizeDefault),
                    // SizedBox(
                    //   height: 100,
                    //   child: ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: Dimensions.paddingSizeDefault),
                    //     itemCount: 5,
                    //     itemBuilder: (context, index) {
                    //       List<Map<String, dynamic>> stores = [
                    //         {
                    //           'name': 'Kenya\nFlowers',
                    //           'color':Theme.of(context).primaryColor,
                    //           'textColor': Colors.white,
                    //           'id': 1,
                    //         },
                    //         {
                    //           'name': 'Assorted\nFlowers',
                    //           'color': Colors.white,
                    //           'textColor':     Theme.of(context).primaryColor,
                    //           'id': 2,
                    //         },
                    //         {
                    //           'name': 'China\nFlowers',
                    //           'color':     Theme.of(context).primaryColor,
                    //           'textColor': Colors.white,
                    //           'id': 3,
                    //         },
                    //         {
                    //           'name': 'Hot\nDeals',
                    //           'color': Colors.white,
                    //           'textColor':      Theme.of(context).primaryColor,
                    //           'id': 4,
                    //         },
                    //         {
                    //           'name': 'Farm\nFlowers',
                    //           'color':   Theme.of(context).primaryColor,
                    //           'textColor': Colors.white,
                    //           'id': 5,
                    //         },
                    //       ];

                    //       return GestureDetector(
                    //         onTap: () {
                    //           // Navigate to store products
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //             SnackBar(
                    //               content: Text('Opening ${stores[index]['name'].replaceAll('\n', ' ')} store'),
                    //               duration: const Duration(seconds: 1),
                    //             ),
                    //           );
                    //         },
                    //         child: Container(
                    //           margin: const EdgeInsets.only(right: 16),
                    //           child: Column(
                    //             children: [
                    //               Container(
                    //                 width: 70,
                    //                 height: 70,
                    //                 decoration: BoxDecoration(
                    //                   color: stores[index]['color'],
                    //                   shape: BoxShape.circle,
                    //                   border: stores[index]['color'] == Colors.white
                    //                       ? Border.all(
                    //                           color: const Color.fromARGB(255, 222, 135, 5),
                    //                           width: 2,
                    //                         )
                    //                       : null,
                    //                   boxShadow: [
                    //                     BoxShadow(
                    //                       color: Colors.grey.withOpacity(0.3),
                    //                       blurRadius: 8,
                    //                       offset: const Offset(0, 2),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 child: Center(
                    //                   child: Text(
                    //                     stores[index]['name'],
                    //                     style: textMedium.copyWith(
                    //                       color: stores[index]['textColor'],
                    //                       fontSize: Dimensions.fontSizeExtraSmall,
                    //                       fontWeight: FontWeight.bold,
                    //                     ),
                    //                     textAlign: TextAlign.center,
                    //                   ),
                    //                 ),
                    //               ),
                    //               const SizedBox(height: 4),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(height: Dimensions.paddingSizeLarge),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  SliverDelegate({required this.child, this.height = 70});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}
