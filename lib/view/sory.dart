import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/const/color.dart';
import 'package:story_view/story_view.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryViewer extends StatefulWidget {
  @override
  _StoryViewerState createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with SingleTickerProviderStateMixin {
  final storyController = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  fetchStories() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference storiesCollection = firestore.collection('stories');

    QuerySnapshot querySnapshot = await storiesCollection.get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;

    List<StoryItem> tempStoryItems = [];
    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['type'] == 'text') {
        tempStoryItems.add(
          StoryItem.text(
            title: data['title'],
            backgroundColor: Colors.redAccent,
            textStyle: TextStyle(),
          ),
        );
      } else if (data['type'] == 'image') {
        tempStoryItems.add(
          StoryItem.pageImage(
            url: data['url'],
            caption: Text(
              data['caption'],
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            controller: storyController,
          ),
        );
      }
    }

    setState(() {
      storyItems = tempStoryItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customBlack2,
        leading: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: customBlack1,
          ),
        ),
      ),
      body: storyItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : StoryView(
              storyItems: data['story']['title'],
              onStoryShow: (storyItem, index) {
                print("Showing a story");
              },
              onComplete: () {
                print("Completed a cycle");
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
              controller: storyController,
            ),
    );
  }
}
