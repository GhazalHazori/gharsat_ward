import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gharsat_ward/features/auth/screens/login_screen.dart';
import 'package:gharsat_ward/features/blog/screens/blog_screen.dart';
import 'package:gharsat_ward/features/cart/controllers/cart_controller.dart' show CartController;
import 'package:gharsat_ward/features/order_details/screens/guest_track_order_screen.dart';
import 'package:gharsat_ward/features/profile/controllers/profile_contrroller.dart';
import 'package:gharsat_ward/features/profile/screens/profile_screen1.dart';
import 'package:gharsat_ward/features/restock/screens/restock_list_screen.dart';
import 'package:gharsat_ward/features/splash/domain/models/config_model.dart';
import 'package:gharsat_ward/features/support/screens/support_ticket_screen.dart';
import 'package:gharsat_ward/features/wallet/controllers/wallet_controller.dart';
import 'package:gharsat_ward/main.dart';

import 'package:gharsat_ward/utill/app_constants.dart';
import 'package:gharsat_ward/features/more/widgets/logout_confirm_bottom_sheet_widget.dart';
import 'package:gharsat_ward/features/chat/screens/inbox_screen.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/features/auth/controllers/auth_controller.dart';
import 'package:gharsat_ward/features/splash/controllers/splash_controller.dart';
import 'package:gharsat_ward/theme/controllers/theme_controller.dart';
import 'package:gharsat_ward/utill/color_resources.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/utill/images.dart';
import 'package:gharsat_ward/features/category/screens/category_screen.dart';
import 'package:gharsat_ward/features/compare/screens/compare_product_screen.dart';
import 'package:gharsat_ward/features/contact_us/screens/contact_us_screen.dart';
import 'package:gharsat_ward/features/coupon/screens/coupon_screen.dart';
import 'package:gharsat_ward/features/more/screens/html_screen_view.dart';
import 'package:gharsat_ward/features/more/widgets/profile_info_section_widget.dart';
import 'package:gharsat_ward/features/more/widgets/more_horizontal_section_widget.dart';
import 'package:gharsat_ward/features/notification/screens/notification_screen.dart';
import 'package:gharsat_ward/features/address/screens/address_list_screen.dart';
import 'package:gharsat_ward/features/refer_and_earn/screens/refer_and_earn_screen.dart';
import 'package:gharsat_ward/features/setting/screens/settings_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'faq_screen_view.dart';
import 'package:gharsat_ward/features/more/widgets/title_button_widget.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});
  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late bool isGuestMode;
  String? version;
  bool singleVendor = false;
  final walletController =
  Provider.of<WalletController>(Get.context!, listen: false);

  @override
  void initState() {
    isGuestMode =
    !Provider.of<AuthController>(context, listen: false).isLoggedIn();
    if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      version = Provider.of<SplashController>(context, listen: false)
          .configModel!
          .softwareVersion ??
          'version';
      Provider.of<ProfileController>(context, listen: false)
          .getUserInfo(context);
    }
    singleVendor = Provider.of<SplashController>(context, listen: false)
        .configModel!
        .businessMode ==
        "single";Provider.of<AuthController>(Get.context!,
        listen: false)
        .getUserToken() !=
        ""
        ?
    Future.microtask(() {

      Provider.of<WalletController>(context, listen: false)
          .getOldestUnpaidTransactions(offset: 1,oldestUnpaid: 1);
    }):null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authController = Provider.of<AuthController>(context, listen: false);
    final bool isGuestMode =
    !Provider.of<AuthController>(context, listen: false).isLoggedIn();
    final ConfigModel? configModel =
        Provider.of<SplashController>(context, listen: false).configModel;
    return Scaffold(
      body: CustomScrollView(
        slivers: [

          // SliverAppBar(
          //     floating: true,
          //     elevation: 0,
          //     expandedHeight: 160,
          //     pinned: true,
          //     centerTitle: false,
          //     automaticallyImplyLeading: false,
          //     backgroundColor: Theme.of(context).highlightColor,
          //     collapsedHeight: 160,
          //     flexibleSpace: const ProfileInfoSectionWidget()),
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
                                    fontSize: 12,
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              Consumer<CartController>(
                                  builder: (context, cart, child) {
                                    return Text(
                                        cart.cartList.length.toString(),
                                        style: textBold.copyWith(
                                          color: ColorResources.black,
                                          fontSize: 12,
                                        ));
                                  }),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                '${getTranslated('credit_limit', context)!}',
                                style: textBold.copyWith(
                                  color: ColorResources.black,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Consumer<WalletController>(
                                  builder: (context, cart, child) {

                                    String datedue = cart.walletTransactionModel?.walletTransactionList == null ||  cart.walletTransactionModel!.walletTransactionList!.isEmpty
                                        ? "..."
                                        : (() {

                                      DateTime createdAt = DateTime.parse(
                                          cart.walletTransactionModel!.walletTransactionList!.last.createdAt!);

                                      DateTime dueDate = createdAt.add(const Duration(days: 15));

                                      return DateFormat('yyyy-MM-dd').format(dueDate);
                                    })();

                                    return Row(
                                      children: [
                                        Text(
                                            datedue,
                                            style: textBold.copyWith(
                                              color: ColorResources.black,
                                              fontSize: 12,
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
                  : const SizedBox()),
          SliverToBoxAdapter(
              child: Container(
                decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
                child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Center(child: MoreHorizontalSection()),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(
                  //       Dimensions.paddingSizeDefault,
                  //       Dimensions.paddingSizeDefault,
                  //       Dimensions.paddingSizeDefault,
                  //       0),
                  //   child: Text(
                  //     getTranslated('general', context) ?? '',
                  //     style: textRegular.copyWith(
                  //         fontSize: Dimensions.fontSizeExtraLarge,
                  //         color: Theme.of(context).colorScheme.onPrimary),
                  //   ),
                  // ),
                  Consumer<SplashController>(
                      builder: (context, splashController, _) {
                        return Container(
                          // padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 159, 156, 156),width: 0.5),
                              borderRadius: BorderRadius.circular(
                                5,),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withValues(alpha: .05),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 1))
                              ],
                              color: Provider.of<ThemeController>(context).darkTheme
                                  ? Colors.white.withValues(alpha: .05)
                                  : Theme.of(context).cardColor),
                          child: Column(children: [
                            // MenuButtonWidget(
                            //   image: Images.trackOrderIcon,
                            //   title: getTranslated('TRACK_ORDER', context),
                            //   navigateTo: const GuestTrackOrderScreen(),
                            // ),
                            if (Provider.of<AuthController>(context, listen: false)
                                .isLoggedIn())
                              MenuButtonWidget(
                                image: Images.user,
                                title: getTranslated('profile', context),
                                navigateTo: const ProfileScreen1(),
                              ),
                            MenuButtonWidget(
                              image: Images.address,
                              title: getTranslated('addresses', context),
                              navigateTo: const AddressListScreen(),
                            ),
                            MenuButtonWidget(
                              image: Images.coupon,
                              title: getTranslated('coupons', context),
                              navigateTo: const CouponList(),
                            ),
                            if (!isGuestMode)
                              if (splashController.configModel?.refEarningStatus ==
                                  "1")
                                MenuButtonWidget(
                                  image: Images.refIcon,
                                  title: getTranslated('refer_and_earn', context),
                                  isProfile: true,
                                  navigateTo: const ReferAndEarnScreen(),
                                ),
                            MenuButtonWidget(
                              image: Images.category,
                              title: getTranslated('CATEGORY', context),
                              navigateTo: const CategoryScreen(),
                            ),
                            // if (Provider.of<AuthController>(context, listen: false)
                            //     .isLoggedIn())
                            //   MenuButtonWidget(
                            //     image: Images.restockIcon,
                            //     title: getTranslated('restock_requests', context),
                            //     navigateTo: const RestockListScreen(),
                            //   ),
                            if (splashController.configModel!.activeTheme !=
                                "default" &&
                                authController.isLoggedIn())
                              MenuButtonWidget(
                                image: Images.compare,
                                title: getTranslated('compare_products', context),
                                navigateTo: const CompareProductScreen(),
                              ),
                            MenuButtonWidget(
                              image: Images.notification,
                              title: getTranslated(
                                'notification',
                                context,
                              ),
                              isNotification: true,
                              navigateTo: const NotificationScreen(),
                            ),
                            MenuButtonWidget(
                              image: Images.settings,
                              title: getTranslated('settings', context),
                              navigateTo: const SettingsScreen(),
                            ),
                            if (splashController.configModel?.blogUrl?.isNotEmpty ??
                                false)
                              MenuButtonWidget(
                                image: Images.blogIcon,
                                title: getTranslated('blog', context),
                                navigateTo: BlogScreen(
                                  url: splashController.configModel?.blogUrl ?? '',
                                ),
                              ),
                          ]),
                        );
                      }),
                  // Padding(
                  //     padding: const EdgeInsets.fromLTRB(
                  //         Dimensions.paddingSizeDefault,
                  //         Dimensions.paddingSizeDefault,
                  //         Dimensions.paddingSizeDefault,
                  //         0),
                  //     child: Text(getTranslated('help_and_support', context) ?? '',
                  //         style: textRegular.copyWith(
                  //             fontSize: Dimensions.fontSizeExtraLarge,
                  //             color: Theme.of(context).colorScheme.onPrimary))),
                  Container(

                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 159, 156, 156),width: 0.5),
                          borderRadius: BorderRadius.circular(
                            5,),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withValues(alpha: .05),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: const Offset(0, 1))
                          ],
                          color: Provider.of<ThemeController>(context).darkTheme
                              ? Colors.white.withValues(alpha: .05)
                              : Theme.of(context).cardColor),
                      child: Column(children: [
                        singleVendor
                            ? const SizedBox()
                            : MenuButtonWidget(
                            image: Images.chats,
                            title: getTranslated('inbox', context),
                            navigateTo: const InboxScreen()),
                        MenuButtonWidget(
                            image: Images.callIcon,
                            title: getTranslated('contact_us', context),
                            navigateTo: const ContactUsScreen()),
                        MenuButtonWidget(
                            image: Images.preference,
                            title: getTranslated('support_ticket', context),
                            navigateTo: const SupportTicketScreen()),
                        MenuButtonWidget(
                            image: Images.termCondition,
                            title: getTranslated('terms_condition', context),
                            navigateTo: HtmlViewScreen(
                              title: getTranslated('terms_condition', context),
                              url: Provider.of<SplashController>(context,
                                  listen: false)
                                  .configModel!
                                  .termsConditions,
                            )),
                        MenuButtonWidget(
                            image: Images.privacyPolicy,
                            title: getTranslated('privacy_policy', context),
                            navigateTo: HtmlViewScreen(
                              title: getTranslated('privacy_policy', context),
                              url: Provider.of<SplashController>(context,
                                  listen: false)
                                  .configModel!
                                  .privacyPolicy,
                            )),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .refundPolicy
                        //         ?.status ==
                        //     1)
                        //   MenuButtonWidget(
                        //       image: Images.termCondition,
                        //       title: getTranslated('refund_policy', context),
                        //       navigateTo: HtmlViewScreen(
                        //         title: getTranslated('refund_policy', context),
                        //         url: Provider.of<SplashController>(context,
                        //                 listen: false)
                        //             .configModel!
                        //             .refundPolicy!
                        //             .content,
                        //       )),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .returnPolicy
                        //         ?.status ==
                        //     1)
                        //   MenuButtonWidget(
                        //       image: Images.termCondition,
                        //       title: getTranslated('return_policy', context),
                        //       navigateTo: HtmlViewScreen(
                        //         title: getTranslated('return_policy', context),
                        //         url: Provider.of<SplashController>(context,
                        //                 listen: false)
                        //             .configModel!
                        //             .returnPolicy!
                        //             .content,
                        //       )),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .cancellationPolicy
                        //         ?.status ==
                        //     1)
                        //   MenuButtonWidget(
                        //       image: Images.termCondition,
                        //       title:
                        //           getTranslated('cancellation_policy', context),
                        //       navigateTo: HtmlViewScreen(
                        //         title: getTranslated(
                        //             'cancellation_policy', context),
                        //         url: Provider.of<SplashController>(context,
                        //                 listen: false)
                        //             .configModel!
                        //             .cancellationPolicy!
                        //             .content,
                        //       )),
                        // if (Provider.of<SplashController>(context,
                        //             listen: false)
                        //         .configModel!
                        //         .shippingPolicy
                        //         ?.status ==
                        //     1)
                        //   MenuButtonWidget(
                        //       image: Images.termCondition,
                        //       title: getTranslated('shipping_policy', context),
                        //       navigateTo: HtmlViewScreen(
                        //         title:
                        //             getTranslated('shipping_policy', context),
                        //         url: Provider.of<SplashController>(context,
                        //                 listen: false)
                        //             .configModel!
                        //             .shippingPolicy!
                        //             .content,
                        //       )),
                        // MenuButtonWidget(
                        //     image: Images.faq,
                        //     title: getTranslated('faq', context),
                        //     navigateTo: FaqScreen(
                        //       title: getTranslated('faq', context),
                        //     )),
                        MenuButtonWidget(
                            image: Images.user,
                            title: getTranslated('about_us', context),
                            navigateTo: HtmlViewScreen(
                              title: getTranslated('about_us', context),
                              url: Provider.of<SplashController>(context,
                                  listen: false)
                                  .configModel!
                                  .aboutUs,
                            ))
                      ])),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Theme.of(context).primaryColor,
                        fixedSize: const Size(400, 20),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (isGuestMode) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        } else {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (_) => const LogoutCustomBottomSheetWidget());
                        }
                      },
                      child: Text(
                        isGuestMode
                            ? getTranslated('sign_in', context)!
                            : getTranslated('sign_out', context)!,
                        style: titilliumRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,color: Colors.white),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       bottom: Dimensions.paddingSizeDefault),
                  //   child:
                  //       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //     Text(
                  //       '${getTranslated('version', context)} ${AppConstants.appVersion}',
                  //       style: textRegular.copyWith(
                  //           fontSize: Dimensions.fontSizeLarge,
                  //           color: Theme.of(context).hintColor),
                  //     ),
                  //   ]),
                  // ),
                ]),
              ))
        ],
      ),
    );
  }
}
