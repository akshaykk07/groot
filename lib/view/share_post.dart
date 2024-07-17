import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:socialapp/const/color.dart';
import 'package:socialapp/controllor/basic_controllor.dart';
import 'package:socialapp/model/post_nodel.dart';
import 'package:socialapp/service/firebase_service.dart';

import '../controllor/image_controllor.dart';
import '../controllor/user_controllor.dart';
import '../widgets/app_text.dart';

class SharePost extends StatelessWidget {
  SharePost({super.key});
  final captioncontrollor = TextEditingController();
  PickImageController pickImage = Get.find();
  BasicControllors basicControllors = Get.find();
  GetuserData userData = Get.find();
  late List<String> filePaths;
  List<String> urls = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    userData.getUservalue();
    return Scaffold(
      backgroundColor: customBlack2,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteone),
        backgroundColor: customBlack2,
        title: const AppText(
          name: 'New Post',
          size: 18,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: whiteone,
              )),
          TextButton(
              onPressed: () async {
                basicControllors.loadingOn();
                filePaths =
                    pickImage.imageFileList.map((file) => file.path).toList();
                try {
                  for (String path in filePaths) {
                    String fileName = path.split('/').last;
                    File file = File(path);

                    // Upload file to Firebase Storage
                    UploadTask uploadTask = FirebaseStorage.instance
                        .ref('uploads/$fileName')
                        .putFile(file);

                    // Get the download URL
                    TaskSnapshot snapshot = await uploadTask;
                    String downloadUrl = await snapshot.ref.getDownloadURL();

                    // log('Uploaded $fileName, download URL: $downloadUrl');
                    urls.add(downloadUrl);
                    log('$urls');
                  }
                } catch (e) {
                  print('Error uploading images: $e');
                }

                FirebaseServices().addPost(
                    userData.id.toString(),
                    PostModel(
                        userId: userData.id.value,
                        urlList: urls,
                        timestamp: DateTime.now().toString(),
                        caption: captioncontrollor.text,
                        location: 'kzkd',
                        likedList: [],
                        username: userData.user_name.toString(),
                        userimage: userData.user_image.toString()));
                basicControllors.loadingOff();
                pickImage.clearImage();
                Navigator.pushNamed(context, 'mainscreen');
              },
              child: const AppText(name: "Share"))
        ],
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ListTile(
                        leading: Container(
                          height: size.height * 0.06,
                          color: whiteone,
                          width: size.width * 0.15,
                          child: Image.file(
                            File(pickImage.imageFileList[0].path),
                            width: size.width * 0.1,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        title: TextField(
                          controller: captioncontrollor,
                          style: const TextStyle(color: whiteone),
                          cursorColor: whiteone,
                          maxLines: 3,
                          decoration: InputDecoration(
                              hintText: 'Caption ..',
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: whiteone)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: whiteone))),
                        ),
                      ),
                      pickImage.imageFileList.length > 1
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: customBlack1)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AppText(
                                    name:
                                        '+${pickImage.imageFileList.length - 1}'),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  const AppText(name: "Add Location"),
                ],
              ),
              basicControllors.isLoading.value
                  ? Container(
                      color: customBlack2,
                      height: size.height,
                      width: size.width,
                      child: const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: customPurple,
                      )))
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
