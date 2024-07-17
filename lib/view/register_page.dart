import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mainscreen.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namecontrollor = TextEditingController();

  final phonecontrollor = TextEditingController();

  bool isLog = false;

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: namecontrollor,
          ),
          TextFormField(
            controller: phonecontrollor,
          ),
          ElevatedButton(
              onPressed: () {
                reg(context);
              },
              child: const Text('Register'))
        ],
      ),
    );
  }

  Future<void> reg(BuildContext context) async {
    final response =
        await FirebaseFirestore.instance.collection('user_registrtion').add({
      'user_name': namecontrollor.text,
      'email': 'A@gmail.coom',
      'user_image':
          'https://t4.ftcdn.net/jpg/08/35/85/09/360_F_835850953_r4AJhFAZzBb3J71dqb7JXxPp5blQFi4C.jpg',
      'phone': phonecontrollor.text,
      'following': [],
      'followers': [],
      'posts': 0,
    });
    SharedPreferences user = await SharedPreferences.getInstance();
    user.setString('user_id', response.id);
    user.setString('user_name', 'Hridhya K');
    user.setString('user_image',
        'https://t4.ftcdn.net/jpg/08/35/85/09/360_F_835850953_r4AJhFAZzBb3J71dqb7JXxPp5blQFi4C.jpg');
    user.setBool('isLogin', true).then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        )));
  }

  checkLogin() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    isLog = user.getBool('isLogin') ?? false;
    if (isLog) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ));
    }
  }
}
