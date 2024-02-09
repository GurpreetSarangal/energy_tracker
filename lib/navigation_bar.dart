import 'package:energy_tracker/my_flutter_app_icons.dart';
import 'package:energy_tracker/pages/dashboard/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 3;

    final controller = Get.put(NavigationController());
    return Scaffold(
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
            onTap: (index) => controller.seletectedIndex.value = index,
            useLegacyColorScheme: false,
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.seletectedIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            // fixedColor: Colors.black,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black.withOpacity(0.7),
            backgroundColor:
                Color.fromARGB(255, 205, 192, 172).withOpacity(0.8),
            items: [
              BottomNavigationBarItem(
                label: "",
                icon: Icon(
                  CupertinoIcons.house,
                  color: Colors.black.withOpacity(0.5),
                  // size: 26,
                ),
                activeIcon: Container(
                  width: 45,
                  height: 45,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 46, 82, 46),
                      borderRadius: BorderRadius.circular(90)),
                  child: Icon(
                    CupertinoIcons.house,
                    color: Color.fromARGB(255, 205, 192, 172),
                    // color: const Color.fromARGB(255, 46, 82, 46),
                    // size: 26,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                  label: "",
                  icon: Container(
                      width: 45,
                      height: 45,
                      padding: EdgeInsets.only(
                          top: 11, bottom: 5, left: 8, right: 8),
                      decoration: BoxDecoration(
                          // color: const Color.fromARGB(255, 46, 82, 46),
                          borderRadius: BorderRadius.circular(90)),
                      child: SvgPicture.asset(
                        "assets/icons/challenge.svg",
                        color: Colors.black.withOpacity(0.7),
                        // color: const Color.fromARGB(255, 46, 82, 46),
                      )),
                  activeIcon: Container(
                      width: 45,
                      height: 45,
                      padding: EdgeInsets.only(
                          top: 11, bottom: 5, left: 8, right: 8),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 46, 82, 46),
                          borderRadius: BorderRadius.circular(90)),
                      child: SvgPicture.asset(
                        "assets/icons/challenge.svg",
                        color: Color.fromARGB(255, 205, 192, 172),
                        // color: const Color.fromARGB(255, 46, 82, 46),
                      ))),
              BottomNavigationBarItem(
                label: "",
                icon: Icon(
                  CupertinoIcons.person_3,
                  // weight: 50,
                  size: 34,
                ),
                activeIcon: Container(
                  width: 45,
                  height: 45,
                  padding:
                      EdgeInsets.only(top: 6, bottom: 8, left: 6, right: 8),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 46, 82, 46),
                      borderRadius: BorderRadius.circular(90)),
                  child: Icon(
                    CupertinoIcons.person_3,
                    size: 34,
                    color: Color.fromARGB(255, 205, 192, 172),
                    // textDirection: TextDirection.ltr,
                    // opticalSize: 540,
                  ),
                  // color: const Color.fromARGB(255, 46, 82, 46),
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: Icon(
                  CupertinoIcons.settings,
                  size: 26,
                ),
                activeIcon: Container(
                    width: 45,
                    height: 45,
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 46, 82, 46),
                        borderRadius: BorderRadius.circular(90)),
                    child: Icon(
                      CupertinoIcons.settings,
                      size: 26,
                      color: Color.fromARGB(255, 205, 192, 172),
                    )
                    // color: const Color.fromARGB(255, 46, 82, 46),
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
    Container(
      color: Colors.amber,
    ),
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.deepOrange,
    )
  ];
}
