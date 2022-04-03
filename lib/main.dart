import 'package:flutter/material.dart';
import './style.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      // ThemeData 찾아서 textTheme.bodyText2의 Style을 적용해줌
      body: Text('안녕', style: Theme.of(context).textTheme.bodyText2),
      // Container 자식부터는 새로운 style을 적용하고 싶을때
      // body: Theme(
      //   data: ThemeData(
      //     textTheme: TextTheme()
      //   ),
      //   child: Container(),
      // ),
    );
  }
}
