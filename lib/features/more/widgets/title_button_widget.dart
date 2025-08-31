import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/custom_asset_image_widget.dart';
import 'package:gharsat_ward/features/notification/controllers/notification_controller.dart';
import 'package:gharsat_ward/features/profile/controllers/profile_contrroller.dart';
import 'package:gharsat_ward/utill/color_resources.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:provider/provider.dart';

class MenuButtonWidget extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;
  final bool isNotification;
  final bool isProfile;
  const MenuButtonWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.navigateTo,
      this.isNotification = false,
      this.isProfile = false});

  @override
  Widget build(BuildContext context) {
    return Container( decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 159, 156, 156),width: 0.5) ),
                      ),
      child: ListTile(
          trailing: isNotification
              ? Consumer<NotificationController>(
                  builder: (context, notificationController, _) {
                  return CircleAvatar(
                    radius: 12,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                        notificationController
                                .notificationModel?.newNotificationItem
                                .toString() ??
                            '0',
                        style: textRegular.copyWith(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeDefault)),
                  );
                })
              : isProfile
                  ? Consumer<ProfileController>(
                      builder: (context, profileProvider, _) {
                      return CircleAvatar(
                          radius: 12,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                              profileProvider.userInfoModel?.referCount
                                      .toString() ??
                                  '0',
                              style: textRegular.copyWith(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.fontSizeDefault)));
                    })
                  : const SizedBox(),
          leading: CustomAssetImageWidget(
            image,
            width: 20,
            height: 20,
            fit: BoxFit.fill,
            color: Theme.of(context).primaryColor.withValues(alpha: .6),
          ),
          title: Text(title!,
              style:
                  titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => navigateTo))),
    );
  }
}
