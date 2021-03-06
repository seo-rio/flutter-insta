import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta/notification.dart';
import 'package:flutter_insta/shop.dart';
import './style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(
      // Store 여러개 사용하려면 MultiProvider
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => Store1()),
          ChangeNotifierProvider(create: (c) => Store2())
        ],
        child: MaterialApp(
          // Web에 전역 CSS 같은거 (다른 파일로 뺄 수 있음)
          theme: theme,
          // initialRoute: '/',
          // routes: {
          //   '/': (c) => Text('첫 페이지'),
          //   '/detail': (c) => Text('두번째 페이지')
          // },
          home: MyApp()
        ),
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
  var userImage;
  var userContent;

  saveData() async {
    var storage = await SharedPreferences.getInstance();

    // 데이터 저장
    storage.setString('name', 'john');
    // 데이터 삭제
    storage.remove('name');
    // 데이터 꺼내기
    var result = storage.getString('name');

    print(result);

    var map = {'age': 20};
    // Map 자료형 저장
    storage.setString('map', jsonEncode(map));
    // Map 자료 꺼내기
    var result2 = storage.getString('map') ?? '데이터 없음';
    print(jsonDecode(result2)['age']);

  }

  // 게시글 작성시 데이터 추가하는 함수
  addMyData() {
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': '5',
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };

    setState(() {
      data.insert(0, myData);
    });
  }

  setUserContent(text) {
    setState(() {
      userContent = text;
    });
  }

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
    saveData();
    getData();
    initNotification(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Text('+'), onPressed: (){
        // showNotification();
        showNotification2();
      },),
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if(image != null) {
                setState(() {
                  userImage = File(image.path);
                });
              }

              // Navigator.push(context,
              //   MaterialPageRoute(builder: (c){return Text('새 페이지');})
              // );
              Navigator.push(context,
                MaterialPageRoute(builder: (c) => Upload(userImage: userImage, setUserContent: setUserContent, addMyData: addMyData))
              );
            },
            iconSize: 30,
          ),
        ]),
      // step2. tab 변수에 따라 보여줄 List 구현
      body: [Home(data: data, moreData: moreData), Shop()][tab],
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
      // 스크롤이 마지막이 됐을 경우
      if(scroll.position.pixels == scroll.position.maxScrollExtent) {
        widget.moreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty) {
      return ListView.builder(
        itemCount: widget.data.length,
        // scroll을 얼마나 했는지 확인할 수 있는 state
        controller: scroll,
        itemBuilder: (c, i){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.data[i]['image'].runtimeType == String ? Image.network(widget.data[i]['image']) : Image.file(widget.data[i]['image']),
            // Text에는 tap 같은 기능이 없으므로 특정 동작을 감지하기 위한 위젯
            GestureDetector(
              child: Text(widget.data[i]['user']),
              onTap: (){
                // Page 전환 커스텀 할려면 PageRouteBuilder, transitionsBuilder 사용
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => Profile(),
                  transitionsBuilder: (c, a1, a2, child) => FadeTransition(opacity: a1, child: child),
                  // 애니메이션 동작 속도 조절
                  transitionDuration: Duration(milliseconds: 500)
                ));
              }),
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

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData}) : super(key: key);

  final userImage;
  final setUserContent;
  final addMyData;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            addMyData();
          }, icon: Icon(Icons.send)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          TextField(onChanged: (text){
            // 유저가 TextField에 입력한 글을 전달
            setUserContent(text);
          }),
          Text('이미지업로드화면'),
          IconButton(
            onPressed: (){
              // Material App Context가 포함되어 있어야함
              Navigator.pop(context);
            },
            icon: Icon(Icons.close)
          ),
        ],
      )
    );
  }
}

class Store1 extends ChangeNotifier {
  var follower = 0;
  var friend = false;

  var profileImage = [];

  getProfileData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }

  addFollower() {
    !friend ? follower++ : follower--;
    friend = !friend ? true : false;
    notifyListeners();
  }
}

class Store2 extends ChangeNotifier {
  var name = 'john Kim';
  changeName() {
    name = 'john park';
    notifyListeners();
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store2>().name) ),
      body: CustomScrollView(
        // slivers 안에는 평소에 쓰던 위젯 아무렇게나 못넣음 SliverXXX 로 시작하는 걸로 넣어야함
        slivers: [
          // Container랑 똑같음
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (c, i) => Image.network(context.watch<Store1>().profileImage[i]),
              childCount: context.watch<Store1>().profileImage.length
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2))
        ],
      )
    );
  }
}

// GridView 사용법
// GridView.builder(
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//   itemBuilder: (BuildContext context, int index) { return Container(color: Colors.grey,); },
//   itemCount: 3,
// )

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        Text('팔로워 ${context.watch<Store1>().follower}명'),
        ElevatedButton(onPressed: (){
          context.read<Store1>().addFollower();
        }, child: Text('팔로우')),
        ElevatedButton(onPressed: (){
          context.read<Store1>().getProfileData();
        }, child: Text('사진 가져오기')),
      ],
    );
  }
}

// Pages 폴더
// Widget 폴더
// Store 폴더