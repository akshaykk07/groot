import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:socialapp/const/color.dart';
import 'package:socialapp/widgets/app_text.dart';

import '../controllor/image_controllor.dart';

class AddPost extends StatelessWidget {
  AddPost({super.key});
  PickImageController pickImageController = Get.find();
  int cindex = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
        backgroundColor: customBlack2,
        appBar: AppBar(
          backgroundColor: customBlack2,
          title: const AppText(
            name: 'Add Post',
            size: 18,
          ),
          actions: [
            pickImageController.imageFileList.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      pickImageController.clearImage();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: whiteone,
                    ))
                : const SizedBox(),
            pickImageController.imageFileList.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'sharepost');
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: whiteone,
                    ))
                : const SizedBox(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: customBlack1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.copy_sharp,
                            color: whiteone,
                          ),
                          AppText(
                            name:
                                ' ${pickImageController.imageFileList.value.length.toString()}',
                            colors: whiteone,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      pickImageController.selectImages();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: customBlack1)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              color: whiteone,
                            ),
                            AppText(
                              name: ' Gallery',
                              colors: whiteone,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      pickImageController.captureImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: customBlack1)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: whiteone,
                            ),
                            AppText(
                              name: 'Camera',
                              colors: whiteone,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.5,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    cindex = index + 1;
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: size.height *
                            .4, // Adjust this to your preferred default height
                        width: size.width,
                        child: Image.file(
                          File(pickImageController.imageFileList[index].path),
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                  itemCount: pickImageController.imageFileList.value.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
