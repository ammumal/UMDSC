import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _happiness = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UM'),
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
              child: Text('Week Challenge',
                  style: TextStyle(
                    fontSize: 20.0,
                  )),
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
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) => {},
          currentIndex: 0,
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
        title: Text('위크 챌린지'),
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
