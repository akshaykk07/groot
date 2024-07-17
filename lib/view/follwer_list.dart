import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:socialapp/controllor/user_controllor.dart';

import '../const/color.dart';
import '../controllor/basic_controllor.dart';
import '../widgets/app_text.dart';
import '../widgets/custom_textfield.dart';

class FollowersList extends StatefulWidget {
  FollowersList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FollowersListState createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  GetuserData userDatas = Get.find();
  BasicControllors basicControllors = Get.find();
  String _searchQuery = '';
  final searchcontrollor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    userDatas.getUservalue();
    return Scaffold(
      backgroundColor: customBlack2,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteone),
        surfaceTintColor: Colors.transparent,
        backgroundColor: customBlack2,
        title: const AppText(
          name: 'Following',
          size: 18,
        ),
      ),
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
              iconclor: customBlack2,
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
                    .doc(userDatas.id.value)
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

                  if (!snapshot.hasData) {
                    return const Center(
                        child: Text(
                      'No posts found',
                      style: TextStyle(color: Colors.grey),
                    ));
                  }
                  basicControllors.getFollowersList(userDatas.id.value);
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  var user = List<String>.from(userData['followers']);

                  // Create a FutureBuilder to fetch user documents asynchronously
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: Future.wait(user.map((userId) async {
                      final userDoc = await FirebaseFirestore.instance
                          .collection('user_registrtion')
                          .doc(userId)
                          .get();
                      return userDoc.data() as Map<String, dynamic>;
                    })),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ));
                      }

                      if (futureSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${futureSnapshot.error}'));
                      }

                      if (!futureSnapshot.hasData) {
                        return const Center(child: Text('No data found'));
                      }

                      var userDocs = futureSnapshot.data!;
                      if (_searchQuery.isNotEmpty) {
                        userDocs = userDocs.where((userData) {
                          final userName = userData['user_name'].toLowerCase();
                          return userName.contains(_searchQuery);
                        }).toList();
                      }

                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final userData = userDocs[index];
                          return ListTile(
                            splashColor: Colors.transparent,
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userData['user_image']),
                            ),
                            title: AppText(name: userData['user_name']),
                            trailing: basicControllors.followingList
                                    .contains(user[index])
                                ? InkWell(
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('user_registrtion')
                                          .doc(userDatas.id.value)
                                          .update({
                                        'following': FieldValue.arrayRemove(
                                            [user[index]]),
                                      });
                                      FirebaseFirestore.instance
                                          .collection('user_registrtion')
                                          .doc(user[index])
                                          .update({
                                        'followers': FieldValue.arrayRemove(
                                            [userDatas.id.value]),
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: customBlue,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: AppText(name: 'Following'),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            onTap: () {
                              Navigator.pushNamed(context, 'friend',
                                  arguments: {'friend_id': user[index]});
                            },
                          );
                        },
                        itemCount: userDocs.length,
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class FollowingList extends StatefulWidget {
  FollowingList({super.key});

  @override
  _FollowingListState createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  GetuserData userDatas = Get.find();
  BasicControllors basicControllors = Get.find();
  String _searchQuery = '';
  final searchcontrollor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    userDatas.getUservalue();
    return Scaffold(
      backgroundColor: customBlack2,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteone),
        surfaceTintColor: Colors.transparent,
        backgroundColor: customBlack2,
        title: const AppText(
          name: 'Following',
          size: 18,
        ),
      ),
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
              txtcolor: whiteone,
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
                    .doc(userDatas.id.value)
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

                  if (!snapshot.hasData) {
                    return const Center(
                        child: Text(
                      'No posts found',
                      style: TextStyle(color: Colors.grey),
                    ));
                  }
                  basicControllors.getFollowersList(userDatas.id.value);
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  var user = List<String>.from(userData['following']);

                  // Create a FutureBuilder to fetch user documents asynchronously
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: Future.wait(user.map((userId) async {
                      final userDoc = await FirebaseFirestore.instance
                          .collection('user_registrtion')
                          .doc(userId)
                          .get();
                      return userDoc.data() as Map<String, dynamic>;
                    })),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ));
                      }

                      if (futureSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${futureSnapshot.error}'));
                      }

                      if (!futureSnapshot.hasData) {
                        return const Center(child: Text('No data found'));
                      }

                      var userDocs = futureSnapshot.data!;
                      if (_searchQuery.isNotEmpty) {
                        userDocs = userDocs.where((userData) {
                          final userName = userData['user_name'].toLowerCase();
                          return userName.contains(_searchQuery);
                        }).toList();
                      }

                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final userData = userDocs[index];
                          return ListTile(
                            splashColor: Colors.transparent,
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userData['user_image']),
                            ),
                            title: AppText(name: userData['user_name']),
                            trailing: basicControllors.followingList
                                    .contains(user[index])
                                ? InkWell(
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('user_registrtion')
                                          .doc(userDatas.id.value)
                                          .update({
                                        'following': FieldValue.arrayRemove(
                                            [user[index]]),
                                      });
                                      FirebaseFirestore.instance
                                          .collection('user_registrtion')
                                          .doc(user[index])
                                          .update({
                                        'followers': FieldValue.arrayRemove(
                                            [userDatas.id.value]),
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: customBlue,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: AppText(name: 'Following'),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            onTap: () {
                              Navigator.pushNamed(context, 'friend',
                                  arguments: {'friend_id': user[index]});
                            },
                          );
                        },
                        itemCount: userDocs.length,
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
