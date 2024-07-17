import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';
import 'package:socialapp/controllor/user_controllor.dart';

import '../model/feed_model.dart';

class BasicControllors extends GetxController {
  RxBool isLoading = false.obs;
  RxList<String> locationlist = <String>[].obs;
  RxInt currentIndex = 0.obs;
  RxList<FeedModel> postList = <FeedModel>[].obs;
  RxList<FeedModel> fpostList = <FeedModel>[].obs;
  RxList<FeedModel> allpostList = <FeedModel>[].obs;
  var followingList = <String>[].obs;
  RxString search = ''.obs;
  RxInt postCount = 0.obs;
  RxInt postCount1 = 0.obs;
  RxBool allpost = true.obs;
  navChange(int value) {
    currentIndex.value = value;
  }

  loadingOn() {
    isLoading.value = true;
  }

  loadingOff() {
    isLoading.value = false;
  }

  addPostList(FeedModel feedModel) {
    postList.add(feedModel);
  }

  addFPostList(FeedModel feedModel) {
    fpostList.add(feedModel);
  }

  addallPostList(FeedModel feedModel) {
    allpostList.add(feedModel);
  }

  chnageCount(newvalue) {
    postCount.value = newvalue;
  }

  chnageCount1(newvalue) {
    postCount1.value = newvalue;
  }

  chnagePage(bool newvalue) {
    allpost.value = newvalue;
  }

  getSearch(value) {
    search.value = value;
  }

  Future<void> getFollowersList(String id) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('user_registrtion')
          .doc(id)
          .get();

      if (result.exists) {
        final data = result.data();
        if (data != null && data.containsKey('following')) {
          followingList.value = List<String>.from(data['following']);
        } else {
          followingList.clear();
          print('Following list is empty.');
        }
      } else {
        print('Document does not exist.');
        followingList.clear();
      }
    } catch (e) {
      print('Error fetching followers: $e');
      followingList.clear();
    }
  }
}
