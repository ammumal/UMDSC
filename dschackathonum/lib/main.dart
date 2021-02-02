import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//63줄 설명봐주세요! -유민서

void main() => runApp(MaterialApp(title: 'MyApp', home: initViewsample()));

class initViewsample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Please choose an animal',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: initView());
  }
}


class initView extends StatefulWidget {
  @override
  _initViewState createState() => _initViewState();
}

class _initViewState extends State<initView> {
  final _valueList = ['북극곰', '코끼리', '뱅갈호랑이', '치타'];
  var _selectedValue = '북극곰';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            DropdownButton(
            value: _selectedValue,
            items: _valueList.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                },
            ).toList(),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
            ),
            RaisedButton(
              child: Text('CHOICE!', style: TextStyle(fontSize: 20.0)),
              color: Colors.blueGrey,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyApp()));
              },
            ),
          ]
          ),
      ),
    );
  }
}


class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green,
        //하단 내비게이션바 배경색
        selectedItemColor: Colors.white,
        //하단 내비게이션바 선택된 아이콘색
        unselectedItemColor: Colors.white.withOpacity(.60),
        //선택되지 않은 아이콘색
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedIndex,
        //현재 선택된 Index
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('Event'),
            icon: Icon(Icons.watch),
          ),
          BottomNavigationBarItem(
            title: Text('Tips'),
            icon: Icon(Icons.book_rounded),
          ),
          BottomNavigationBarItem(
            title: Text('My Page'),
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  List _widgetOptions = [
    //각 함수 호출하여 화면 이동 -> 맡은 부분에 해당하는 함수에서 작업하시면 됩니다!
    Home(), //일단은 탭 순서대로 해놨어요! Home 함수만 해도 길이가 꽤 되니깐 ctrl+f로 함수 검색해서 찾아주세요
    Event(), //상단 appbar는 제가 통일하긴 했는데 그냥 생각나는 제목이 없어서 임의로 한거니깐 맡은 분들이 바꿔주세요
    Tips(),
    MyPage()
  ];
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _happiness = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Green Day',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 130,
            ),
            Row(children: <Widget>[
              SizedBox(
                width: 250,
              ),
              Text('행복지수: $_happiness',
                  style: TextStyle(
                    fontSize: 20.0,
                  )),
            ]),
            Image.asset(
              'assets/6.png',
            ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              child: Text('Week Challenge', style: TextStyle(fontSize: 20.0)),
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WeekChallengePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WeekChallengePage extends StatefulWidget {
  @override
  _WeekChallengePageState createState() => _WeekChallengePageState();
}

class Challenges {
  String challenges;
  bool clear = false;

  Challenges(this.challenges);
}

class _WeekChallengePageState extends State<WeekChallengePage> {
  var count = 6;

  final _items = [
    Challenges('환경 마크가 있는 상품 구매하기'),
    Challenges('과일과 야채를 많이 먹는 날 정하기'),
    Challenges('가까운 거리는 걷거나 자전거 이용하기'),
    Challenges('텀블러나 개인 컵 사용하기'),
    Challenges('양치컵 사용하기'),
    Challenges('식사는 먹을 만큼만 차리고 싹싹 비우기'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          '위크 챌린지',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: count > 0
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: _items
                  .map((challenges) => _buildItemWidget(challenges))
                  .toList(),
            ),
          )
              : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  '오늘의 챌린지를 모두\n완료했습니다!',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) => {},
          currentIndex: 0,
          backgroundColor: Colors.green,
          //하단 내비게이션바 배경색
          selectedItemColor: Colors.white,
          //하단 내비게이션바 선택된 아이콘색
          unselectedItemColor: Colors.white.withOpacity(.60),
          //선택되지 않은 아이콘색
          selectedFontSize: 14,
          unselectedFontSize: 14,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.watch), label: 'Event'),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_rounded), label: 'Tips'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'My Page'),
          ]),
    );
  }

  Widget _buildItemWidget(Challenges challenges) {
    return InkWell(
      onTap: () {
        setState(() {
          challenges.clear = !challenges.clear;
        });
        count--;
      },
      child: challenges.clear
          ? Container()
          : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.tag_faces),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      '${challenges.challenges}',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.tag_faces),
                  SizedBox(
                    width: 10,
                  ),
                  Text('행복 5개')
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}


class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('event', style: TextStyle(color: Colors.green)),
        ));
  }
}


class Tips extends StatefulWidget {
  @override
  _TipsState createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title:
          Text('How to save the earth?', style: TextStyle(color: Colors.green)),
        ));
  }
}


class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('my Page', style: TextStyle(color: Colors.green)),
      ),
      body: ListView(
        children: <Widget>[
          _buildTop(),
          _buildMiddle(),
          _buildBottom(),
        ],
      ),
    );
  }
}

Widget _buildTop() {
  return Padding(
    padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
    child: Column(
      children: <Widget>[
        TextField(
          style: TextStyle(height: 0.3),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'email을 입력하세요'
          ),
        ),
        TextField(
          style: TextStyle(height: 0.3),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password를 입력하세요'
          ),
        ),
        Text('google 계정으로 로그인'),
      ],
    ),
  );
}

Widget _buildMiddle() {
  int count = 0;

  return Center(
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(' 2021-01 ', style: TextStyle(fontSize: 35)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Icon(
                        Icons.stars,
                        size: 100,
                        color: Colors.amber,
                      ),
                      Text('참여횟수'),
                      Text(
                        '6',
                        style: TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Icon(
                        Icons.event_available,
                        size: 100,
                        color: Colors.amber,
                      ),
                      Text('이벤트'),
                      Text(
                        '2',
                        style: TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        width: 380,
        height: 250,
      ),
    ),
  );
}

Widget _buildBottom() {
  var _isChecked = false;
  /*
  final items = List.generate(1, (i){
    return ListTile(
      leading: Icon(Icons.chevron_right),
      title: Text('알람')
  });
  return ListView(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    children: items,
  );
  */
  return Column(
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.chevron_right),
        title: Text('알림설정'),
        trailing: Switch(
          value: _isChecked,
          onChanged: (value) {
            _isChecked = value;
          },
        ),
      ),
      ListTile(
        leading: Icon(Icons.chevron_right),
        title: Text(
            'ABOUT GREEN DAY\n\nGlobal warming is the long-term heating of Earths climate '
                'system observed since the pre-industrial period (between 1850 and 1900) due'
                ' to human activities, primarily fossil fuel burning, which increases h'
                'eat-trapping greenhouse gas levels in Earths atmosphere.\n\n'
                'Since the pre-industrial period, human activities are estimated to have increased Earths global average '
                'temperature by about 1 degree Celsius (1.8 degrees Fahrenheit), '
                'a number that is currently increasing by 0.2 degrees Celsius (0.36 degrees Fahrenheit) per decade. '
                'Most of the current warming trend is extremely likely (greater than 95 percent probability) the resu'
                'lt of human activity since the 1950s and is proceeding at an unprecedented rate over decades to millennia.\n\nThank you.'),
        subtitle: Text('[개발자 강예빈, 유민서, 윤여경, 이지은]'),

      ),
    ],

  );
}

/*
FirebaseAuth auth = FirebaseAuth.instance;
GoogleSignIn googleSignIn = GoogleSignIn();


GoogleSignInAccount account = await googleSignIn.signIn();

GoogleSignInAuthentication authentication = await account.authentication;

AuthCredential credential = GoogleAuthProvider.getCredential(
    idToken: authentication.idToken, accessToken: authentication.accessToken);
AuthResult authResult = await auth.signInWithCredential(credential);

FirebaseUser user = authResult.user;
*/
