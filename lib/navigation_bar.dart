import 'package:energy_tracker/loginMethods/google_sign_in.dart';
import 'package:energy_tracker/main.dart';
import 'package:energy_tracker/my_flutter_app_icons.dart';
import 'package:energy_tracker/pages/challenges/all_challenges.dart';
import 'package:energy_tracker/pages/community/leaderboard.dart';
import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:energy_tracker/pages/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:googleapis/analytics/v3.dart';

    final controller = Get.put(NavigationController());
class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 3;

    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Obx(() => controller.screens[controller.seletectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            selectedFontSize:
                12.5, // landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            onTap: (index) => controller.seletectedIndex.value = index,
            useLegacyColorScheme: false,
            type: BottomNavigationBarType.values[0],
            currentIndex: controller.seletectedIndex.value,
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            // fixedColor: Colors.black,
            selectedItemColor: Colors.black,
            // unselectedItemColor: Colors.black.withOpacity(0.5),
            unselectedItemColor: Color.fromARGB(211, 76, 68, 48),
            backgroundColor:
                // Color.fromARGB(255, 205, 192, 172).withOpacity(0.5),
                Colors.white,
            elevation: 23,
            enableFeedback: false,
            // backgroundColor:
            //     Color.fromARGB(255, 205, 192, 172).withOpacity(0.8),
            items: [
              BottomNavigationBarItem(
                label: "Home",
                icon: Icon(
                  CupertinoIcons.home,
                  // color: Colors.black.withOpacity(0.5),
                  // size: 20,
                ),
                
              ),
              BottomNavigationBarItem(
                label: "Challenges",
                icon: SvgPicture.asset(
                  "assets/icons/challenge.svg",
                  height: 25,
                  color: Colors.black.withOpacity(0.5),
                  // fit: BoxFit.fitWidth,
                  // color: const Color.fromARGB(255, 46, 82, 46),
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/challenge.svg",
                  height: 25,
                  color: Colors.black.withOpacity(1),
                  // fit: BoxFit.fitWidth,
                  // color: const Color.fromARGB(255, 46, 82, 46),
                ),
              
              ),
              BottomNavigationBarItem(
                label: "Community",
                icon: Icon(
                  CupertinoIcons.person_2,
                  // weight: 50,
                  // size: 22,
                ),
                
              ),
              BottomNavigationBarItem(
                label: "Profile",
                icon: Icon(
                  CupertinoIcons.person_crop_circle,
                  size: 22,
                ),
              
              )
            ]),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final RxInt seletectedIndex = 0.obs;

  final screens = [
    Dashboard(),
    AllChallenges(),
    Leaderboard(),
    ProfilePage(),
  ];
}
