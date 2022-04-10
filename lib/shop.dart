import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
final auth = FirebaseAuth.instance;

final firestroe = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  getData() async {
    try{
      // 데이터 가져오기
      var result = await firestroe.collection('product').get();

      // 데이터 저장
      // await firestroe.collection('product').add({'name': '내복', 'price': 5000});

      if(result.docs.isNotEmpty) {
        for(var doc in result.docs) {
          print(doc['name']);
        }
      }
    }catch (e){
      print('에러남');
    }
  }

  addAuth() async {
    try {
      var result = await auth.createUserWithEmailAndPassword(
        email: "kim@test.com",
        password: "123456",
      );
      print(result.user);
    } catch (e) {
      print(e);
    }
  }

  login() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: 'kim@test.com',
          password: '123456'
      );
    } catch (e) {
      print(e);
    }

    if(auth.currentUser?.uid == null){
      print('로그인 안된 상태군요');
    } else {
      print('로그인 하셨네');
    }
  }

  logout() async {
    await auth.signOut();
  }

  authGetData() async {
    if(auth.currentUser?.uid == null){
      print('로그인 안된 상태군요');
    } else {
      print('로그인 하셨네');
    }
    await firestroe.collection('product').get();
  }

  @override
  void initState() {
    super.initState();
    // getData();
    // addAuth();
    // login();
    // logout();
    authGetData();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵페이지!!!!!'),
    );
  }
}
