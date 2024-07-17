import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/const/color.dart';

import '../controllor/basic_controllor.dart';
import '../controllor/image_controllor.dart';
import 'add_post.dart';
import 'home_Screen.dart';
import 'profile.dart';
import 'search_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  List screens = [HomeScreen(), SearchScreen(), AddPost(), UserProfile()];
  BasicControllors basicControllors = Get.find();
  PickImageController pickImageController = Get.find();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
        body: screens[basicControllors.currentIndex.value],
        bottomNavigationBar: Container(
          color: customBlack2,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    basicControllors.navChange(0);
                  },
                  child: Icon(
                    Icons.home_outlined,
                    color: basicControllors.currentIndex == 0
                        ? customPurple
                        : whiteone,
                  ),
                ),
                InkWell(
                  onTap: () {
                    basicControllors.navChange(1);
                  },
                  child: Icon(
                    Icons.search,
                    color: basicControllors.currentIndex == 1
                        ? customPurple
                        : whiteone,
                  ),
                ),
                InkWell(
                  onTap: () {
                    basicControllors.navChange(2);
                    pickImageController.selectImages();
                  },
                  child: Icon(
                    Icons.add_box_outlined,
                    color: basicControllors.currentIndex == 2
                        ? customPurple
                        : whiteone,
                  ),
                ),
                InkWell(
                  onTap: () {
                    basicControllors.navChange(3);
                  },
                  child: Icon(
                    Icons.person_2_outlined,
                    color: basicControllors.currentIndex == 3
                        ? customPurple
                        : whiteone,
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
