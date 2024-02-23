import 'package:energy_tracker/loginMethods/google_sign_in.dart';
import 'package:energy_tracker/main.dart';
import 'package:energy_tracker/my_flutter_app_icons.dart';
import 'package:energy_tracker/pages/challenges/all_challenges.dart';
import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:energy_tracker/pages/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:googleapis/analytics/v3.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 3;

    final controller = Get.put(NavigationController());
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar: NavigationBar(
      //   elevation: 0,
      //   selectedIndex: 0,
      //   height: 80,
      //   backgroundColor: Color.fromARGB(255, 205, 192, 172).withOpacity(0.8),
      //   overlayColor: MaterialStateProperty.resolveWith<Color?>(
      //     (Set<MaterialState> states) {
      //       if (states.contains(MaterialState.pressed)) {
      //         return const Color.fromARGB(255, 100, 157, 100);
      //       }
      //       return null;
      //     },
      //   ),
      //   // indicatorShape: ,
      //   indicatorColor: const Color.fromARGB(255, 46, 82, 46),
      //   destinations: [
      //     NavigationDestination(
      //       icon: Icon(
      //         CupertinoIcons.house_alt,
      //         color: const Color.fromARGB(255, 46, 82, 46),
      //       ),
      //       label: "",
      //       selectedIcon: Icon(
      //         CupertinoIcons.house_alt,
      //         color: Color.fromARGB(255, 205, 192, 172).withOpacity(1),
      //       ),
      //     ),
      //     NavigationDestination(
      //       icon: SvgPicture.asset("assets/icons/challenge.svg"),
      //       label: "",
      //       selectedIcon: SvgPicture.asset("assets/icons/challenge.svg"),
      //     ),
      //     NavigationDestination(
      //         icon: Icon(
      //           CupertinoIcons.person_3,
      //           size: 33,
      //         ),
      //         label: ""),
      //     NavigationDestination(icon: Icon(CupertinoIcons.settings), label: ""),
      //   ],
      // ),
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
            unselectedItemColor: Color(0xff4c4430),
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
                // activeIcon: Container(
                //   width: 30,
                //   height: 30,
                //   margin: EdgeInsets.only(top: 10),
                //   // padding: EdgeInsets.only(top: 4, right: 6, left: 7),
                //   decoration: BoxDecoration(
                //       // color: const Color.fromARGB(255, 46, 82, 46),
                //       color: Color.fromARGB(255, 197, 189, 179),
                //       borderRadius: BorderRadius.circular(90)),
                //   child: Icon(
                //     CupertinoIcons.home,
                //     // color: Color.fromARGB(255, 205, 192, 172),
                //     // color: const Color.fromARGB(255, 46, 82, 46),
                //     size: 20,
                //   ),
                // ),
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
                // activeIcon: Container(
                //     width: 30,
                //     height: 30,
                //     padding:
                //         EdgeInsets.only(top: 8, bottom: 2, left: 4, right: 4),
                //     decoration: BoxDecoration(
                //         // color: const Color.fromARGB(255, 46, 82, 46),
                //         color: Color.fromARGB(255, 197, 189, 179),
                //         borderRadius: BorderRadius.circular(90)),
                //     child: SvgPicture.asset(
                //       "assets/icons/challenge.svg",
                //       // color: Color.fromARGB(255, 205, 192, 172),
                //       allowDrawingOutsideViewBox: true,
                //       fit: BoxFit.contain,
                //       height: 30,
                //       width: 30,
                //       // color const Color.fromARGB(255, 46, 82, 46),
                //     ))
              ),
              BottomNavigationBarItem(
                label: "Community",
                icon: Icon(
                  CupertinoIcons.person_2,
                  // weight: 50,
                  // size: 22,
                ),
                // activeIcon: Container(
                //   width: 30,
                //   height: 30,
                //   padding:
                //       EdgeInsets.only(top: 6, bottom: 8, left: 6, right: 8),
                //   decoration: BoxDecoration(
                //       // color: const Color.fromARGB(255, 46, 82, 46),
                //       color: Color.fromARGB(255, 197, 189, 179),
                //       borderRadius: BorderRadius.circular(90)),
                //   child: Icon(
                //     CupertinoIcons.person_2,
                //     size: 22,
                //     // color: Color.fromARGB(255, 205, 192, 172),
                //     // textDirection: TextDirection.ltr,
                //     // opticalSize: 540,
                //   ),
                //   // color: const Color.fromARGB(255, 46, 82, 46),
                // ),
              ),
              BottomNavigationBarItem(
                label: "Profile",
                icon: Icon(
                  CupertinoIcons.person_crop_circle,
                  size: 22,
                ),
                // activeIcon: Container(
                //     width: 30,
                //     height: 30,
                //     padding: EdgeInsets.all(4),
                //     decoration: BoxDecoration(
                //         // color: Color.fromARGB(255, 139, 180, 139),
                //         color: Color.fromARGB(255, 197, 189, 179),
                //         borderRadius: BorderRadius.circular(90)),
                //     child: Icon(
                //       CupertinoIcons.settings,
                //       size: 22,
                //       // color: Color.fromARGB(255, 205, 192, 172),
                //     )
                //     // color: const Color.fromARGB(255, 46, 82, 46),
                //     ),
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
    allChallenges(),
    Container(
      color: Colors.blue,
    ),
    ProfilePage(),
  ];
}
