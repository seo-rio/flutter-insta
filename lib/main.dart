import 'package:flutter/material.dart';
import './style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';

void main() {
  runApp(
      MaterialApp(
        // Web에 전역 CSS 같은거 (다른 파일로 뺄 수 있음)
        theme: theme,
        home: MyApp()
      )
  );
}

var a = TextStyle();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // step1. 현재 탭의 상태 선언
  var tab = 0;
  var data = [];

  getData() async {
    // Dio package 사용하면 훨씬 유용함
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2;
    });
  }

  moreData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    setState(() {
      data.add(result2);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: (){},
            iconSize: 30,
          ),
        ]),
      // step2. tab 변수에 따라 보여줄 List 구현
      body: [Home(data: data, moreData: moreData), Text('샵페이지')][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          // step3. tab 상태 변경 구현
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵'),
        ],
      ),

    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, this.data, this.moreData}) : super(key: key);

  final data;
  final moreData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    // scroll될때마다 실행하는 함수
    scroll.addListener(() {
      print(scroll.position.pixels);
      // 스크롤이 마지막이 됐을 경우
      if(scroll.position.pixels == scroll.position.maxScrollExtent) {
        widget.moreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // StatefulWidget안에있는 변수를 사용하려면 widget.변수명
    print(widget.data);
    if(widget.data.isNotEmpty) {
      return ListView.builder(
        itemCount: widget.data.length,
        // scroll을 얼마나 했는지 확인할 수 있는 state
        controller: scroll,
        itemBuilder: (c, i){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.data[i]['image']),
            Text('좋아요 ${widget.data[i]['likes']}'),
            Text(widget.data[i]['date']),
            Text(widget.data[i]['content']),
          ],
        );
      });
    }else{
      return Text('로딩중');
    }
  }
}

