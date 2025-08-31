import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/bouncy_widget.dart';
import 'package:gharsat_ward/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:gharsat_ward/features/auth/domain/services/auth_service_interface.dart';
import 'package:gharsat_ward/features/landing/screens/landing_screen.dart';
import 'package:gharsat_ward/features/order_details/screens/order_details_screen.dart';
import 'package:gharsat_ward/features/product_details/screens/product_details_screen.dart';
import 'package:gharsat_ward/features/splash/controllers/splash_controller.dart';
import 'package:gharsat_ward/features/splash/domain/models/config_model.dart';
import 'package:gharsat_ward/features/update/screen/update_screen.dart';
import 'package:gharsat_ward/features/wallet/screens/wallet_screen.dart';
import 'package:gharsat_ward/helper/network_info.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/push_notification/models/notification_body.dart';
import 'package:gharsat_ward/features/auth/controllers/auth_controller.dart';
import 'package:gharsat_ward/utill/app_constants.dart';
import 'package:gharsat_ward/utill/color_resources.dart';
import 'package:gharsat_ward/utill/images.dart';
import 'package:gharsat_ward/common/basewidget/no_internet_screen_widget.dart';
import 'package:gharsat_ward/features/chat/screens/inbox_screen.dart';
import 'package:gharsat_ward/features/dashboard/screens/dashboard_screen.dart';
import 'package:gharsat_ward/features/maintenance/maintenance_screen.dart';
import 'package:gharsat_ward/features/notification/screens/notification_screen.dart';
import 'package:gharsat_ward/features/onboarding/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';

import '../../../theme/controllers/theme_controller.dart';

class SplashScreen extends StatefulWidget {
  
  final NotificationBody? body;
  const SplashScreen({super.key, this.body});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  // late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
    late final AuthServiceInterface authServiceInterface;
 
  @override
  void initState() {
    super.initState();


    // bool firstTime = true;
    // _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   if(!firstTime) {
    //     bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
    //     isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: isNotConnected ? Colors.red : Colors.green,
    //       duration: Duration(seconds: isNotConnected ? 6000 : 3),
    //       content: Text(isNotConnected ? getTranslated('no_connection', context)! : getTranslated('connected', context)!,
    //         textAlign: TextAlign.center)));
    //     if(!isNotConnected) {
    //       _route();
    //     }
    //   }
    //   firstTime = false;
    // });

    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _route();
  }

  @override
  void dispose() {
    super.dispose();
    // _onConnectivityChanged.cancel();
  }
  

  void _route() {
    
    // NetworkInfo.checkConnectivity(context);
    Provider.of<SplashController>(context, listen: false).initConfig(context,
        (ConfigModel? configModel) {
      String? minimumVersion = "0";
      UserAppVersionControl? appVersion =
          Provider.of<SplashController>(Get.context!, listen: false)
              .configModel
              ?.userAppVersionControl;
      // mr_edit
      if (defaultTargetPlatform == TargetPlatform.android) {
        minimumVersion = appVersion?.forAndroid?.version ?? '0';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        minimumVersion = appVersion?.forIos?.version ?? '0';
      }
      Provider.of<SplashController>(Get.context!, listen: false)
          .initSharedPrefData();
      // Timer(const Duration(seconds: 2), () {
      final config = Provider.of<SplashController>(Get.context!, listen: false)
          .configModel;

      Future.delayed(const Duration(milliseconds: 0)).then((_) {
       print(Provider.of<AuthController>(Get.context!, listen: false).getUserToken());
        if(Provider.of<AuthController>(Get.context!, listen: false).getUserToken()==""){

    Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
            builder: (_) => const LandingScreen(),
         
          ));
        }
       else if (compareVersions(minimumVersion!, AppConstants.appVersion) == 1) {
          Navigator.of(Get.context!).pushReplacement(
              MaterialPageRoute(builder: (_) => const UpdateScreen()));
        } 
        // else if (config?.maintenanceModeData?.maintenanceStatus == 1 &&
        //     config?.maintenanceModeData?.selectedMaintenanceSystem
        //             ?.customerApp ==
        //         1 &&
        //     !Provider.of<SplashController>(Get.context!, listen: false)
        //         .isConfigCall) {
        //   Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
        //     builder: (_) => const MaintenanceScreen(),
        //     settings: const RouteSettings(name: 'MaintenanceScreen'),
        //   ));
        // } 
        else if (Provider.of<AuthController>(Get.context!, listen: false)
            .isLoggedIn()) {
          Provider.of<AuthController>(Get.context!, listen: false)
              .updateToken(Get.context!);
          if (widget.body != null) {
            if (widget.body!.type == 'order') {
              Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      OrderDetailsScreen(orderId: widget.body!.orderId)));
            } else if (widget.body!.type == 'notification') {
              Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const NotificationScreen()));
            } else if (widget.body!.type == 'wallet') {
              Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const WalletScreen()));
            } else if (widget.body!.type == 'chatting') {
              Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => InboxScreen(
                      isBackButtonExist: true,
                      fromNotification: true,
                      initIndex:
                          widget.body!.messageKey == 'message_from_delivery_man'
                              ? 0
                              : 1)));
            } else if (widget.body!.type == 'product_restock_update') {
              Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => ProductDetails(
                      productId: int.parse(widget.body!.productId!),
                      slug: widget.body!.slug,
                      isNotification: true)));
            } else {
              Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const NotificationScreen(
                        fromNotification: true,
                      )));
            }
          } else {
            Navigator.of(Get.context!).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const DashBoardScreen(),
                transitionDuration:
                    Duration.zero, // Removes transition duration
                reverseTransitionDuration:
                    Duration.zero, // Removes reverse transition
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) => child,
              ),
            );
          }
        } 
        else if (Provider.of<SplashController>(Get.context!, listen: false)
            .showIntro()!) {
          Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LandingScreen(
              )));
        } 
        else {
          if (Provider.of<AuthController>(Get.context!, listen: false)
                      .getGuestToken() !=
                  null &&
              Provider.of<AuthController>(Get.context!, listen: false)
                      .getGuestToken() !=
                  '1') {
            Navigator.of(Get.context!).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const DashBoardScreen(),
                transitionDuration:
                    Duration.zero, // Removes transition duration
                reverseTransitionDuration:
                    Duration.zero, // Removes reverse transition
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) => child,
              ),
            );
          } else {
            Provider.of<AuthController>(Get.context!, listen: false)
                .getGuestIdUrl();

            Navigator.of(Get.context!).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const DashBoardScreen(),
                transitionDuration:
                    Duration.zero, // Removes transition duration
                reverseTransitionDuration:
                    Duration.zero, // Removes reverse transition
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) => child,
              ),
            );
          }
        }
      });
      //  });
    }, (ConfigModel? configModel) {
      String? minimumVersion = "0";
      UserAppVersionControl? appVersion =
          Provider.of<SplashController>(Get.context!, listen: false)
              .configModel
              ?.userAppVersionControl;
      // mr_edit
      if (defaultTargetPlatform == TargetPlatform.android) {
        minimumVersion = appVersion?.forAndroid?.version ?? '0';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        minimumVersion = appVersion?.forIos?.version ?? '0';
      }
      Provider.of<SplashController>(Get.context!, listen: false)
          .initSharedPrefData();
      // Timer(const Duration(seconds: 1), () {
      final config = Provider.of<SplashController>(Get.context!, listen: false)
          .configModel;
      if (compareVersions(minimumVersion, AppConstants.appVersion) == 1) {
        Navigator.of(Get.context!).pushReplacement(
            MaterialPageRoute(builder: (_) => const UpdateScreen()));
      } else if (config?.maintenanceModeData?.maintenanceStatus == 1 &&
          config?.maintenanceModeData?.selectedMaintenanceSystem?.customerApp ==
              1 &&
          !config!.localMaintenanceMode!) {
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
          builder: (_) => const MaintenanceScreen(),
          settings: const RouteSettings(name: 'MaintenanceScreen'),
        ));
      } else if (Provider.of<AuthController>(Get.context!, listen: false)
              .isLoggedIn() &&
          !configModel!.hasLocaldb!) {
        Provider.of<AuthController>(Get.context!, listen: false)
            .updateToken(Get.context!);
        if (widget.body != null) {
          if (widget.body!.type == 'order') {
            Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) =>
                    OrderDetailsScreen(orderId: widget.body!.orderId)));
          } else if (widget.body!.type == 'notification') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const NotificationScreen()));
          } else if (widget.body!.type == 'wallet') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const WalletScreen()));
          } else if (widget.body!.type == 'chatting') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => InboxScreen(
                    isBackButtonExist: true,
                    fromNotification: true,
                    initIndex:
                        widget.body!.messageKey == 'message_from_delivery_man'
                            ? 0
                            : 1)));
          } else if (widget.body!.type == 'product_restock_update') {
            Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => ProductDetails(
                    productId: int.parse(widget.body!.productId!),
                    slug: widget.body!.slug,
                    isNotification: true)));
          } else {
            Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const NotificationScreen(
                      fromNotification: true,
                    )));
          }
        } else {
          Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const DashBoardScreen()));
        }
      }
       else if (Provider.of<SplashController>(Get.context!, listen: false)
              .showIntro()! &&
          !configModel!.hasLocaldb!) {
        Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LandingScreen(
            
                )));
      } 
      else if (!configModel!.hasLocaldb! ||
          (configModel.hasLocaldb! &&
              configModel.localMaintenanceMode! &&
              !(config?.maintenanceModeData?.maintenanceStatus == 1 &&
                  config?.maintenanceModeData?.selectedMaintenanceSystem
                          ?.customerApp ==
                      1))) {
        if (Provider.of<AuthController>(Get.context!, listen: false)
                    .getGuestToken() !=
                null &&
            Provider.of<AuthController>(Get.context!, listen: false)
                    .getGuestToken() !=
                '1') {
          Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const DashBoardScreen()));
        } else {
          Provider.of<AuthController>(Get.context!, listen: false)
              .getGuestIdUrl();
          Navigator.pushAndRemoveUntil(
              Get.context!,
              MaterialPageRoute(builder: (_) => const DashBoardScreen()),
              (route) => false);
        }
      }
      // });
    }).then((bool isSuccess) {
      if (isSuccess) {}
    });
  }

  int compareVersions(String version1, String version2) {
    List<String> v1Components = version1.split('.');
    List<String> v2Components = version2.split('.');
    for (int i = 0; i < v1Components.length; i++) {
      int v1Part = int.parse(v1Components[i]);
      int v2Part = int.parse(v2Components[i]);
      if (v1Part > v2Part) {
        return 1;
      } else if (v1Part < v2Part) {
        return -1;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeController>(context).darkTheme
          ? ColorResources.black
          : ColorResources.white,
      key: _globalKey,
      body: Provider.of<SplashController>(context).hasConnection
          ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                BouncyWidget(
                    duration: const Duration(milliseconds: 2000),
                    lift: 50,
                    ratio: 0.5,
                    pause: 0.25,
                    child: SizedBox(
                        width: 150,
                        child: Image.asset(Images.icon, width: 150.0))),
              ]),
            )
          : const NoInternetOrDataScreenWidget(
              isNoInternet: true, child: SplashScreen()),
    );
  }
}
