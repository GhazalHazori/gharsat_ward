import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/features/auth/domain/models/register_model.dart';
import 'package:gharsat_ward/features/auth/screens/login_screen.dart';
import 'package:gharsat_ward/features/auth/widgets/condition_check_box_widget.dart';
import 'package:gharsat_ward/features/profile/controllers/profile_contrroller.dart';
import 'package:gharsat_ward/helper/velidate_check.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/features/auth/controllers/auth_controller.dart';
import 'package:gharsat_ward/features/splash/controllers/splash_controller.dart';
import 'package:gharsat_ward/utill/custom_themes.dart';
import 'package:gharsat_ward/utill/dimensions.dart';
import 'package:gharsat_ward/utill/images.dart';
import 'package:gharsat_ward/common/basewidget/custom_button_widget.dart';
import 'package:gharsat_ward/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:gharsat_ward/common/basewidget/custom_textfield_widget.dart';
import 'package:gharsat_ward/features/dashboard/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  SignUpWidgetState createState() => SignUpWidgetState();
}

class SignUpWidgetState extends State<SignUpWidget> {
  // mr_edit
  String? _selectedCityId;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referController = TextEditingController();

  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referFocus = FocusNode();

  RegisterModel register = RegisterModel();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  route(bool isRoute, String? token, String? tempToken,
      String? errorMessage) async {
    var splashController =
        Provider.of<SplashController>(context, listen: false);
    var authController = Provider.of<AuthController>(context, listen: false);
    var profileController =
        Provider.of<ProfileController>(context, listen: false);
    String phone =
        authController.countryDialCode + _phoneController.text.trim();
    if (isRoute) {
      if (splashController.configModel!.emailVerification!) {
        authController
            .sendOtpToEmail(_emailController.text.toString(), tempToken!)
            .then((value) async {
          if (value.response?.statusCode == 200) {
            authController.updateEmail(_emailController.text.toString());
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>
            //     VerificationScreen(tempToken,'',_emailController.text.toString())), (route) => false);
          }
        });
      } else if (splashController.configModel!.phoneVerification!) {
        authController.sendOtpToPhone(phone, tempToken!).then((value) async {
          if (value.isSuccess) {
            authController.updatePhone(phone);
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>
            //     VerificationScreen(tempToken,phone,'')), (route) => false);
          }
        });
      } else {
        await profileController.getUserInfo(context);
        Navigator.pushAndRemoveUntil(
            Get.context!,
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
            (route) => false);
        _emailController.clear();
        _passwordController.clear();
        _firstNameController.clear();
        _lastNameController.clear();
        _phoneController.clear();
        _confirmPasswordController.clear();
        _referController.clear();
      }
    } else {
      showCustomSnackBar(errorMessage, context);
    }
  }

  @override
  void initState() {
    super.initState();

    Provider.of<AuthController>(context, listen: false).setCountryCode(
        CountryCode.fromCountryCode(
                Provider.of<SplashController>(context, listen: false)
                    .configModel!
                    .countryCode!)
            .dialCode!,
        notify: false);

    // mr_edit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthController>(context, listen: false).fetchCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final config =
        Provider.of<SplashController>(context, listen: false).configModel;
    return Column(
      children: [
        Consumer<AuthController>(builder: (context, authProvider, _) {
          return Consumer<SplashController>(
              builder: (context, splashProvider, _) {
            return Form(
              key: signUpFormKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: Dimensions.paddingSizeExtraSmall,
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault),
                      child: CustomTextFieldWidget(
                          hintText: getTranslated('first_name', context),
                          labelText: getTranslated('first_name', context),
                          inputType: TextInputType.name,
                          required: true,
                          focusNode: _fNameFocus,
                          nextFocus: _lNameFocus,
                          prefixIcon: Images.username,
                          capitalization: TextCapitalization.words,
                          controller: _firstNameController,
                          validator: (value) => ValidateCheck.validateEmptyText(
                              value, "first_name_field_is_required"))),
                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault,
                          top: Dimensions.marginSizeSmall),
                      child: CustomTextFieldWidget(
                          hintText: getTranslated('last_name', context),
                          labelText: getTranslated('last_name', context),
                          focusNode: _lNameFocus,
                          prefixIcon: Images.username,
                          nextFocus: _emailFocus,
                          required: true,
                          capitalization: TextCapitalization.words,
                          controller: _lastNameController,
                          validator: (value) => ValidateCheck.validateEmptyText(
                              value, "last_name_field_is_required"))),
                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault,
                          top: Dimensions.marginSizeSmall),
                      child: CustomTextFieldWidget(
                          hintText: getTranslated('enter_your_email', context),
                          labelText: getTranslated('enter_your_email', context),
                          focusNode: _emailFocus,
                          nextFocus: _phoneFocus,
                          required: true,
                          inputType: TextInputType.emailAddress,
                          controller: _emailController,
                          prefixIcon: Images.email,
                          validator: (value) =>
                              ValidateCheck.validateEmail(value))),
                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault,
                          top: Dimensions.marginSizeSmall),
                      child: CustomTextFieldWidget(
                          hintText:
                              getTranslated('enter_mobile_number', context),
                          labelText:
                              getTranslated('enter_mobile_number', context),
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          nextFocus: _passwordFocus,
                          required: true,
                          showCodePicker: true,
                          countryDialCode: authProvider.countryDialCode,
                          onCountryChanged: (CountryCode countryCode) {
                            _phoneFocus.requestFocus();
                            authProvider.countryDialCode =
                                countryCode.dialCode!;
                            authProvider.setCountryCode(countryCode.dialCode!);
                          },
                          isAmount: true,
                          validator: (value) => ValidateCheck.validateEmptyText(
                              value, "phone_must_be_required"),
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.phone)),
                  // mr_edit
                  authProvider.isLoadingCity
                      ? Container(
                          margin: const EdgeInsets.only(
                              left: Dimensions.marginSizeDefault,
                              right: Dimensions.marginSizeDefault,
                              top: Dimensions.marginSizeSmall),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).highlightColor),
                          child: Shimmer.fromColors(
                            baseColor: Theme.of(context).cardColor,
                            highlightColor: Colors.grey[300]!,
                            enabled: true,
                            child: Container(
                              height: 50,
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(
                              top: Dimensions.marginSizeSmall),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButtonFormField<String>(
                            value: _selectedCityId,
                            style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.all(Dimensions.fontSizeDefault),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFBFBFBF),
                                  width: 0.75,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFBFBFBF),
                                  width: 0.75,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 0.75,
                                ),
                              ),
                              label: Text.rich(TextSpan(
                                children: [
                                  TextSpan(
                                    text: getTranslated(
                                        'please_select_city', context),
                                    style: textRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    ),
                                  ),
                                ],
                              )),
                              prefixIcon: Icon(
                                Icons.place,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha:  0.4),
                              ),
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).hintColor,
                            ),
                            items: authProvider.cities
                                .map((city) => DropdownMenuItem<String>(
                                      value: city.id.toString(),
                                      child: Text(
                                        city.name,
                                        style: textRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedCityId = value;
                              });
                            },
                          ),
                        ),

                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault,
                          top: Dimensions.marginSizeSmall),
                      child: CustomTextFieldWidget(
                          hintText:
                              getTranslated('minimum_password_length', context),
                          labelText: getTranslated('password', context),
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          isPassword: true,
                          required: true,
                          nextFocus: _confirmPasswordFocus,
                          inputAction: TextInputAction.next,
                          validator: (value) => ValidateCheck.validatePassword(
                              value, "password_must_be_required"),
                          prefixIcon: Images.pass)),

                  Hero(
                      tag: 'user',
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: Dimensions.marginSizeDefault,
                              right: Dimensions.marginSizeDefault,
                              top: Dimensions.marginSizeSmall),
                          child: CustomTextFieldWidget(
                              isPassword: true,
                              required: true,
                              hintText:
                                  getTranslated('re_enter_password', context),
                              labelText:
                                  getTranslated('re_enter_password', context),
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              inputAction: TextInputAction.done,
                              validator: (value) =>
                                  ValidateCheck.validateConfirmPassword(
                                      value, _passwordController.text.trim()),
                              prefixIcon: Images.pass))),
                  if (splashProvider.configModel!.refEarningStatus != null &&
                      splashProvider.configModel!.refEarningStatus == "1")
                    // Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault),
                    //   child: Row(children: [Text(getTranslated('refer_code', context)??'')])),
                    if (splashProvider.configModel!.refEarningStatus != null &&
                        splashProvider.configModel!.refEarningStatus == "1")
                      Container(
                          margin: const EdgeInsets.only(
                              left: Dimensions.marginSizeDefault,
                              right: Dimensions.marginSizeDefault,
                              top: Dimensions.marginSizeSmall),
                          child: CustomTextFieldWidget(
                              hintText:
                                  getTranslated('enter_refer_code', context),
                              labelText:
                                  getTranslated('referral_code', context),
                              controller: _referController,
                              focusNode: _referFocus,
                              prefixIcon: Images.referImage,
                              prefixColor: Theme.of(context).primaryColor,
                              inputAction: TextInputAction.done)),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  const ConditionCheckBox(),

                  Container(
                      margin:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Hero(
                        tag: 'onTap',
                        child: CustomButton(
                          isLoading: authProvider.isLoading,
                          onTap: authProvider.isAcceptTerms
                              ? () {
                                  String firstName =
                                      _firstNameController.text.trim();
                                  String lastName =
                                      _lastNameController.text.trim();
                                  String email = _emailController.text.trim();
                                  String phoneNumber =
                                      authProvider.countryDialCode +
                                          _phoneController.text.trim();
                                  String password =
                                      _passwordController.text.trim();

                                  if (signUpFormKey.currentState?.validate() ??
                                      false) {
                                    register.fName = firstName;
                                    register.lName = lastName;
                                    register.email = email;
                                    register.phone = phoneNumber;
                                    register.password = password;
                                    register.referCode =
                                        _referController.text.trim();
                                    // mr_edit
                                    register.cityId = _selectedCityId;
                                    authProvider.registration(
                                      register,
                                      route,
                                      config!,
                                    );
                                  }
                                }
                              : null,
                          buttonText: getTranslated('sign_up', context),
                        ),
                      )),
                  authProvider.isLoading
                      ? const SizedBox()
                      : Center(
                          child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: Dimensions.paddingSizeExtraLarge),
                          child: InkWell(
                            onTap: () {
                              authProvider.getGuestIdUrl();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LoginScreen()));
                            },
                            child: Column(
                              children: [
                                Text(
                                  getTranslated(
                                      'already_have_account', context)!,
                                  style: titleRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(getTranslated('sign_in', context)!,
                                        style: titilliumRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: Dimensions.iconSizeExtraSmall,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                ],
              ),
            );
          });
        }),
      ],
    );
  }
}
