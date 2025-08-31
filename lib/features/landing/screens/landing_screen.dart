import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gharsat_ward/features/auth/screens/login_screen.dart';
import 'package:gharsat_ward/features/dashboard/screens/dashboard_screen.dart';
import 'package:gharsat_ward/features/landing/controller/your_tap_controller.dart';
import 'package:gharsat_ward/localization/controllers/localization_controller.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/utill/app_constants.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override int selectedIndex = 0;

  void initState() {
    selectedIndex = Provider.of<LocalizationController>(context, listen: false)
        .languageIndex!;
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 232, 226, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(child: Image.asset("assets/images/logo.png", width: 200)),
            
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 50),
            
            // Language Selector
             Consumer<LocalizationController>(
              builder: (context, localizationProvider, _) {return
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                 
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(221, 170, 115, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Consumer<YourTabController>(
                    builder: (context, tabController, child) {
                      return Row(
                        children: [
                          // English Button
                          Expanded(
                            child: GestureDetector(
                               onTap: () {
                                tabController.changeTab(0);
                                setState(() {}); 
                                setState(() {
                          selectedIndex = 0;
                        });
                             Provider.of<LocalizationController>(context, listen: false)
                          .setLanguage(Locale(
                              AppConstants.languages[selectedIndex].languageCode!,
                              AppConstants.languages[selectedIndex].countryCode));// إضافة هذه السطر لفرض إعادة بناء الواجهة
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: tabController.currentTab == 0
                                    ? BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:selectedIndex==0? const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ): const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      )
                                    : null,
                                child: Text(
                                  'English',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: tabController.currentTab == 0
                                        ? const Color.fromRGBO(221, 170, 115, 1)
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Arabic Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                tabController.changeTab(1);
                                setState(() {}); 
                                setState(() {
                          selectedIndex = 1;
                        });
                             Provider.of<LocalizationController>(context, listen: false)
                          .setLanguage(Locale(
                              AppConstants.languages[selectedIndex].languageCode!,
                              AppConstants.languages[selectedIndex].countryCode));// إضافة هذه السطر لفرض إعادة بناء الواجهة
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: tabController.currentTab == 1
                                    ? BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:selectedIndex==0? const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ): const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      )
                                    : null,
                                child: Text(
                                  'Arabic',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: tabController.currentTab == 1
                                        ? const Color.fromRGBO(221, 170, 115, 1)
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );},
            ),
            
            SizedBox(height: 50),
                SizedBox(
                 width: 320,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to home screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child:  Text(
          getTranslated('sign_in', context)!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: const Color.fromRGBO(221, 170, 115, 1)
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: 80),
                // Continue as Guest Button
                SizedBox(
                width: 320,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to home screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const DashBoardScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(221, 170, 115, 1),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child:  Text(
                      getTranslated('continue_as_guest', context)!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}