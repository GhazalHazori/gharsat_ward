import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gharsat_ward/common/basewidget/product_deal_widget.dart';
import 'package:gharsat_ward/features/address/controllers/address_controller.dart';
import 'package:gharsat_ward/features/auth/controllers/auth_controller.dart';
import 'package:gharsat_ward/features/banner/controllers/banner_controller.dart';
import 'package:gharsat_ward/features/brand/controllers/brand_controller.dart';
import 'package:gharsat_ward/features/cart/controllers/cart_controller.dart';
import 'package:gharsat_ward/features/category/controllers/category_controller.dart';
import 'package:gharsat_ward/features/cities/city_controller.dart';
import 'package:gharsat_ward/features/deal/controllers/featured_deal_controller.dart';
import 'package:gharsat_ward/features/deal/controllers/flash_deal_controller.dart';
import 'package:gharsat_ward/features/home/screens/home_screens.dart';
import 'package:gharsat_ward/features/notification/controllers/notification_controller.dart';
import 'package:gharsat_ward/features/product/controllers/product_controller.dart';
import 'package:gharsat_ward/features/product/domain/models/product_model.dart';
import 'package:gharsat_ward/features/product/enums/product_type.dart';
import 'package:gharsat_ward/features/product/widgets/products_list_widget.dart';
import 'package:gharsat_ward/features/profile/controllers/profile_contrroller.dart';
import 'package:gharsat_ward/features/shop/controllers/shop_controller.dart';
import 'package:gharsat_ward/features/splash/controllers/splash_controller.dart';
import 'package:gharsat_ward/features/splash/domain/models/config_model.dart';
import 'package:gharsat_ward/helper/responsive_helper.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/common/basewidget/no_internet_screen_widget.dart';
import 'package:gharsat_ward/common/basewidget/product_shimmer_widget.dart';
import 'package:gharsat_ward/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gharsat_ward/utill/images.dart';
import 'package:provider/provider.dart';

class DealView extends StatefulWidget {
  final String title;
  
  const DealView({
    super.key,
    required this.title,
  });

  @override
  State<DealView> createState() => _DealViewState();
}

class _DealViewState extends State<DealView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = true;
  bool _isGridView = true;
  String _selectedSort = 'Default';
  String _selectedCountry = 'All';
  List<Product> _filteredProducts = [];
  List<Product> _allProducts = [];

  List<String> sortOptions = [
    'Default',
    'Price: Low to High',
    'Price: High to Low',
    'Name: A to Z',
    'Name: Z to A',
    'Latest',
  ];

  List<String> countryFilters = [
    'All',
    'Thailand',
    'Malaysia',
    'Singapore',
    'Indonesia',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final productController = Provider.of<ProductController>(context, listen: false);
    await productController.getDiscountedProductList(1, true);
    if (mounted) {
      setState(() {
        _allProducts = productController.discountedProductModel?.products ?? [];
        _filteredProducts = List.from(_allProducts);
        _isLoading = false;
      });
    }
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(_allProducts);
      } else {
        _filteredProducts = _allProducts.where((product) {
          return product.name!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      _applySorting();
    });
  }

  void _applyCountryFilter(String country) {
    setState(() {
      _selectedCountry = country;
      if (country == 'All') {
        _filteredProducts = List.from(_allProducts);
      } else {
        // Apply country filter logic here
        _filteredProducts = _allProducts.where((product) {
          // Add your country filtering logic
          return true; // For now, return all products
        }).toList();
      }
      _performSearch(_searchController.text);
    });
  }

  void _applySorting() {
    setState(() {
      switch (_selectedSort) {
        case 'Price: Low to High':
          _filteredProducts.sort((a, b) => (a.unitPrice ?? 0).compareTo(b.unitPrice ?? 0));
          break;
        case 'Price: High to Low':
          _filteredProducts.sort((a, b) => (b.unitPrice ?? 0).compareTo(a.unitPrice ?? 0));
          break;
        case 'Name: A to Z':
          _filteredProducts.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
          break;
        case 'Name: Z to A':
          _filteredProducts.sort((a, b) => (b.name ?? '').compareTo(a.name ?? ''));
          break;
        case 'Latest':
          _filteredProducts.sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: robotoBold.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 1,
        iconTheme: IconThemeData(color: Theme.of(context).textTheme.bodyLarge?.color),
        actions: [
          // Grid/List view toggle
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          // Sort menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (String value) {
              setState(() {
                _selectedSort = value;
                _applySorting();
              });
            },
            itemBuilder: (BuildContext context) {
              return sortOptions.map((String option) {
                return PopupMenuItem<String>(
                  value: option,
                  child: Row(
                    children: [
                      Icon(
                        _selectedSort == option ? Icons.check : Icons.radio_button_unchecked,
                        color: _selectedSort == option ? Theme.of(context).primaryColor : null,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(option),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    color: Theme.of(context).cardColor,
                    child: TextField(
                      controller: _searchController,
                      onChanged: _performSearch,
                      decoration: InputDecoration(
                        hintText: 'Search within products',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                  
                  // Country Filter Tabs
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      itemCount: countryFilters.length,
                      itemBuilder: (context, index) {
                        final country = countryFilters[index];
                        final isSelected = _selectedCountry == country;
                        
                        return GestureDetector(
                          onTap: () => _applyCountryFilter(country),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? const Color.fromARGB(255, 222, 135, 5)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected 
                                    ? const Color.fromARGB(255, 222, 135, 5)
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              country,
                              style: textMedium.copyWith(
                                color: isSelected ? Colors.white : Colors.grey.shade700,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Products List/Grid
                  _filteredProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Images.noProduct,
                                width: 150,
                                height: 150,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                              Text(
                                'No products found',
                                style: titilliumRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadInitialData,
                          child: _isGridView
                              ? SingleChildScrollView(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: MasonryGridView.count(
                                    crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    itemCount: _filteredProducts.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ProductWidget(
                                        productModel: _filteredProducts[index],
                                      );
                                    },
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  itemCount: _filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: ProductDealWidget(
                                        productModel: _filteredProducts[index],
                                      ),
                                    );
                                  },
                                ),
                        ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Keep the original widget for backward compatibility
class DiscountedProductListWidget extends StatefulWidget {
  final bool isHomePage;
  final ScrollController? scrollController;

  static Future<void> loadData(bool reload) async {
    final flashDealController = Provider.of<FlashDealController>(Get.context!, listen: false);
    final shopController = Provider.of<ShopController>(Get.context!, listen: false);
    final categoryController = Provider.of<CategoryController>(Get.context!, listen: false);
    final bannerController = Provider.of<BannerController>(Get.context!, listen: false);
    final addressController = Provider.of<AddressController>(Get.context!, listen: false);
    final productController = Provider.of<ProductController>(Get.context!, listen: false);
    final brandController = Provider.of<BrandController>(Get.context!, listen: false);
    final featuredDealController = Provider.of<FeaturedDealController>(Get.context!, listen: false);
    final notificationController = Provider.of<NotificationController>(Get.context!, listen: false);
    final cartController = Provider.of<CartController>(Get.context!, listen: false);
    final profileController = Provider.of<ProfileController>(Get.context!, listen: false);
    final splashController = Provider.of<SplashController>(Get.context!, listen: false);

    if (flashDealController.flashDealList.isEmpty || reload) {
      await flashDealController.getFlashDealList(reload, false);
    }

    splashController.initConfig(Get.context!, null, null);
    categoryController.getCategoryList(reload);
    bannerController.getBannerList(reload);
    shopController.getTopSellerList(reload, 1, type: "top");
    shopController.getAllSellerList(reload, 1, type: "all");

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
    productController.getDiscountedProductList(1,reload);

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

  const DiscountedProductListWidget({
    super.key,
    required this.isHomePage,
    this.scrollController,
  });

  @override
  State<DiscountedProductListWidget> createState() => _DiscountedProductListWidgetState();
}

class _DiscountedProductListWidgetState extends State<DiscountedProductListWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool singleVendor = false;

  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashController>(context, listen: false)
            .configModel!
            .businessMode ==
        "single";
    
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final productController = Provider.of<ProductController>(context, listen: false);
    await  productController.getDiscountedProductList(1, true);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer<ProductController>(
          builder: (context, productController, child) {
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (productController.discountedProductModel == null || productController.discountedProductModel!.products ==null  ) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Images.noProduct,
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Text(
                      getTranslated('no_discounted_products', context) ?? 
                      'No discounted products available',
                      style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await _loadInitialData();
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          Dimensions.paddingSizeDefault,
                          Dimensions.paddingSizeDefault,
                          Dimensions.paddingSizeSmall,
                          0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                getTranslated('discounted_product', context) ?? 
                                'Discounted Products',
                                style: titleHeader,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall,
                        ),
                        child: ListView.builder(
                       
                          itemCount: productController.discountedProductModel!.products!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return ProductDealWidget(
                              productModel: productController.discountedProductModel!.products![index],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.homePagePadding),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
