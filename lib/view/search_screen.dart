import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socialapp/const/color.dart';
import 'package:socialapp/controllor/basic_controllor.dart';
import 'package:socialapp/widgets/app_text.dart';
import 'package:socialapp/widgets/custom_textfield.dart';

import '../controllor/user_controllor.dart';
import '../model/feed_model.dart';
import 'post_view.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  BasicControllors basicControllors = Get.find();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: customBlack2,
        appBar: AppBar(
          backgroundColor: customBlack2,
          title: const AppText(
            name: 'Search',
            size: 18,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: Column(
            children: [
              SizedBox(
                child: Padding(
                    padding: EdgeInsets.only(
                      right: size.width * 0.5,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            basicControllors.chnagePage(true);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: customBlack2,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: customBlack1)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02,
                                    vertical: size.height * 0.005),
                                child: const AppText(
                                  name: 'All',
                                  colors: whiteone,
                                )),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            basicControllors.chnagePage(false);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: customBlack2,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: customBlack1)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02,
                                    vertical: size.height * 0.005),
                                child: const AppText(
                                  name: 'Account',
                                  colors: white,
                                )),
                          ),
                        )
                      ],
                    )),
              ),
              Obx(() => Expanded(
                  child: basicControllors.allpost.value
                      ? AllPosts()
                      : const AllAccounts()))
            ],
          ),
        ),
      ),
    );
  }
}

class AllPosts extends StatelessWidget {
  AllPosts({super.key});
  final searchcontrollor = TextEditingController();
  BasicControllors basicControllors = Get.find();
  GetuserData userData = Get.find();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    userData.getUservalue();
    return Scaffold(
      backgroundColor: customBlack2,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.02,
            ),
            child: CustomTextField2(
              hint: 'Search',
              controller: searchcontrollor,
              validator: (val) {},
              icon: Icons.search,
              iconclor: whiteone,
              prefix: true,
              txtcolor: customBlack1,
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('time_stamps', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: customPurple,
                  ));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No posts found'));
                }

                final posts = snapshot.data!.docs;
                basicControllors.allpostList.clear();
                return Expanded(
                  child: MasonryGridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      List likedBy = posts[index]['likes'];
                      int likeCount = likedBy.length + 1;
                      bool like = false;
                      if (likedBy.contains(userData.id.value)) {
                        like = true;
                      } else {
                        like = false;
                      }
                      List saved = posts[index]['saved'];
                      bool isSave = false;
                      if (saved.contains(userData.id.value)) {
                        isSave = true;
                      } else {
                        isSave = false;
                      }
                      FeedModel newPost = FeedModel(
                          postid: posts[index].id,
                          profileimage: posts[index]['user_image'],
                          postimage: posts[index]['url'],
                          caption: posts[index]['caption'],
                          likecount: likeCount.toString(),
                          commentcount: '2',
                          timestamp: posts[index]['time_stamp'],
                          username: posts[index]['user_name'],
                          isLike: like,
                          isSaved: isSave);

                      // Check if the post already exists in the list

                      bool postExists = basicControllors.allpostList
                          .any((post) => post.postid == newPost.postid);

                      // If the post does not exist, add it to the list
                      if (!postExists) {
                        basicControllors.allpostList.add(newPost);
                      }
                      final imgurl = List<String>.from(posts[index]['url']);
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllPostView(index: index),
                              ));
                        },
                        child: CachedNetworkImage(
                          fit: BoxFit.fitHeight,
                          imageUrl: imgurl.isNotEmpty ? imgurl[0] : '',
                          placeholder: (context, url) => Container(
                            color: customBlack1,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      );
                    },
                    itemCount: posts.length,
                  ),
                );
              }),
        ],
      ),
    );
  }
}

// Assuming customBlack2, customPurple, and customBlack1 are defined elsewhere in your project
class AllAccounts extends StatefulWidget {
  const AllAccounts({super.key});

  @override
  _AllAccountsState createState() => _AllAccountsState();
}

class _AllAccountsState extends State<AllAccounts> {
  String _searchQuery = '';
  final searchcontrollor = TextEditingController();
  BasicControllors basicControllors = Get.find();
  GetuserData userDatas = Get.find();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    userDatas.getUservalue();
    return Scaffold(
      backgroundColor: customBlack2,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.02,
            ),
            child: CustomTextField2(
              hint: 'Search',
              controller: searchcontrollor,
              validator: (val) {},
              icon: Icons.search,
              iconclor: whiteone,
              prefix: true,
              txtcolor: customBlack1,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('user_registrtion')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: AppText(
                    name: 'No accounts found',
                    colors: whiteone,
                  ));
                }

                final documents = snapshot.data!.docs;
                basicControllors.getFollowersList(userDatas.id.value);
                final filteredDocs = documents.where((doc) {
                  final name = doc['user_name'].toString().toLowerCase();
                  return name.contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final document = filteredDocs[index];
                    return Obx(
                      () => ListTile(
                        splashColor: Colors.transparent,
                        leading: SizedBox(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              fit: BoxFit.fitHeight,
                              imageUrl: document['user_image'],
                              placeholder: (context, url) => Container(
                                color: customBlack1,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        title: AppText(
                          name: document['user_name'],
                          size: 15,
                        ),
                        trailing: basicControllors.followingList
                                .contains(document.id)
                            ? InkWell(
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection('user_registrtion')
                                      .doc(userDatas.id.value)
                                      .update({
                                    'following':
                                        FieldValue.arrayRemove([document.id]),
                                  });
                                  FirebaseFirestore.instance
                                      .collection('user_registrtion')
                                      .doc(document.id)
                                      .update({
                                    'followers': FieldValue.arrayRemove(
                                        [userDatas.id.value]),
                                  });
                                },
                                child: Container(
                                  height: size.height * 0.03,
                                  width: size.width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: customBlue,
                                  ),
                                  child: const Center(
                                      child: AppText(name: 'Following')),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection('user_registrtion')
                                      .doc(userDatas.id.value)
                                      .update({
                                    'following':
                                        FieldValue.arrayUnion([document.id]),
                                  });
                                  FirebaseFirestore.instance
                                      .collection('user_registrtion')
                                      .doc(document.id)
                                      .update({
                                    'followers': FieldValue.arrayUnion(
                                        [userDatas.id.value]),
                                  });
                                },
                                child: Container(
                                  height: size.height * 0.03,
                                  width: size.width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: customBlue,
                                  ),
                                  child: const Center(
                                      child: AppText(name: 'Follow')),
                                ),
                              ),
                        onTap: () {
                          Navigator.pushNamed(context, 'friend',
                              arguments: {'friend_id': document.id});
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


// class AccountSearchDelegate extends SearchDelegate {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('user_registration')
//           .where('user_name', isGreaterThanOrEqualTo: 'akshay kk')
//           .where('user_name', isLessThanOrEqualTo: 'akshay kk')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return const Center(child: Text('Something went wrong'));
//         }

//         final documents = snapshot.data?.docs ?? [];

//         return ListView.builder(
//           itemCount: documents.length,
//           itemBuilder: (context, index) {
//             final document = documents[index];
//             return ListTile(
//               title: Text(document['user_name']),
//               subtitle:
//                   Text(document['email']), // Assuming you have an email field
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return Container();
//   }
// }
