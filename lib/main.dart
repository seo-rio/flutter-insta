import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
        // Web에 전역 CSS 같은거 (다른 파일로 뺄 수 있음)
        theme: ThemeData(
          iconTheme: IconThemeData(
            color: Colors.blue
          ),
          appBarTheme: AppBarTheme(
            color: Colors.grey,
            // Deep 한 위젯은 새롭게 다시 설정해줘야할때가 있음
            actionsIconTheme: IconThemeData(color: Colors.red)
          ),
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.red),
          ),
        ),
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
      appBar: AppBar(actions: [Icon(Icons.star)]),
      // body: Icon(Icons.star),
      body: Text('안녕'),
    );
  }
}
