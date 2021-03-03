import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(title: 'MyApp', home: initViewsample()));


int eventDone = 0;


class initViewsample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Please choose an animal',
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
            children: <Widget>[
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
                    if(value =='북극곰'){
                      Firestore.instance.collection('userData').document('ILMQl5nJoRBL7RlfLtrd').updateData(
                          {'animalNumber': 0});
                    }
                    else if(value =='코끼리'){
                      Firestore.instance.collection('userData').document('ILMQl5nJoRBL7RlfLtrd').updateData(
                          {'animalNumber': 1});
                    }
                    else if(value =='뱅갈호랑이'){
                      Firestore.instance.collection('userData').document('ILMQl5nJoRBL7RlfLtrd').updateData(
                          {'animalNumber': 2});
                    }
                    else if(value == '치타'){
                      Firestore.instance.collection('userData').document('ILMQl5nJoRBL7RlfLtrd').updateData(
                          {'animalNumber': 3});
                    }
                  });
                },
              ),
              RaisedButton(
                child: Text('CHOICE!', style: TextStyle(fontSize: 20.0)),
                color: Colors.blueGrey,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
              ),
            ]),
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

//선택한 동물 데이터
class Animal {
  int animalNumber; //동물 번호(0: 북극곰, 1: 코끼리, 2: 뱅갈호랑이, 3: 치타)

  Animal(this.animalNumber);
}

//챌린지 항목 데이터
class Challenge {
  String title; //챌린지 내용
  bool clear; //챌린지 클리어 여부
  int point; //챌린지에 부여된 행복 지수
  int iconNumber; //챌린지 아이콘

  Challenge(this.title, this.point, this.iconNumber, {this.clear = false});
}

//행복 지수 데이터
class Happiness {
  int point; //행복지수
  Happiness(this.point);
}

//하루가 지났는지 확인하고, 챌린지 및 행복지수 리셋을 위한 데이터
class UpdateDay {
  bool update = false;
  int count = 6;
  DateTime dt;
  bool display = false;

  UpdateDay({this.dt});
}

UpdateDay updateDay = new UpdateDay();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //웃는 동물 사진 리스트
  var happyAnimalList = [
    'assets/happyAnimal0.png',
    'assets/happyAnimal1.png',
    'assets/happyAnimal2.png',
    'assets/happyAnimal3.png'
  ];

  //우는 동물 사진 리스트
  var sadAnimalList = [
    'assets/sadAnimal0.png',
    'assets/sadAnimal1.png',
    'assets/sadAnimal2.png',
    'assets/sadAnimal3.png'
  ];

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
              height: 50,
            ),
            StreamBuilder<QuerySnapshot>( //행복지수, 동물 그림
              stream: Firestore.instance.collection('userData').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final documents = snapshot.data.documents;
                return Column(
                  children:
                      documents.map((doc) => _buildItemWidget(doc)).toList(),
                );
              },
            ),
            RaisedButton( // Week Challenge 버튼
              child: Text('Daily Challenge',
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              color: Colors.lightGreen,
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

  //행복 지수, 동물 그림 버튼 위젯
  Widget _buildItemWidget(DocumentSnapshot doc) {
    final happiness = Happiness(doc['point']);
    final animal = Animal(doc['animalNumber']);

    var now = new DateTime.now();
    updateDay.dt = new DateTime.fromMillisecondsSinceEpoch(
        doc['updateTime'].seconds * 1000);

    //하루가 지났을 경우, 날짜 변경 시간을 다음 날로 업데이트
    if (now.isAfter(updateDay.dt)) {
      //한 달이 지났을 경우(월이 달라질 경우) 메인 페이지 챌린지 횟수 초기화
      if(now.month != updateDay.dt.month){
        Firestore.instance
            .collection('userData')
            .document(doc.documentID)
            .updateData({'monthlyCount': 0});
      }
      Firestore.instance
          .collection('userData')
          .document(doc.documentID)
          .updateData({'point': 0});
      var up = doc['updateTime'].seconds + 86400;
      Firestore.instance
          .collection('userData')
          .document(doc.documentID)
          .updateData({'updateTime': Timestamp(up, 0)});
      Firestore.instance
          .collection('userData')
          .document(doc.documentID)
          .updateData({'updateTime': Timestamp(up, 0)});

      //후에 challenge 화면 불러올 때 초기화 해야함을 표시
      updateDay.update = true;
    }

    if (happiness.point < 100) { //행복지수가 100 미만일 때 슬픈 동물 사진 보이기
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 250,
              ),
              Text('행복지수: ${happiness.point}',
                  style: TextStyle(
                    fontSize: 20.0,
                  )),
            ],
          ),
          Image.asset(
            sadAnimalList[animal.animalNumber],
            height: 400,
            width: 300,
          ),
        ],
      );
    } else {  //행복지수가 100 이상일 때 행복한 동물 사진 보이기
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 250,
              ),
              Text('행복지수: ${happiness.point}',
                  style: TextStyle(
                    fontSize: 20.0,
                  )),
            ],
          ),
          Image.asset(
            happyAnimalList[animal.animalNumber],
            height: 400,
            width: 300,
          ),
        ],
      );
    }
  }
}

class WeekChallengePage extends StatefulWidget {
  @override
  _WeekChallengePageState createState() => _WeekChallengePageState();
}

//데일리 챌린지 페이지
class _WeekChallengePageState extends State<WeekChallengePage> {
  //챌린지별 아이콘 리스트
  var iconList = [
    Icon(Icons.clear),
    Icon(Icons.access_alarm),
    Icon(Icons.airport_shuttle),
    Icon(Icons.wb_incandescent_outlined),
    Icon(Icons.wash_outlined),
    Icon(Icons.delete)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Daily Challenge',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: StreamBuilder<QuerySnapshot>(
              //챌린지 항목들
              stream: Firestore.instance.collection('challenge').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final documents = snapshot.data.documents;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children:
                        documents.map((doc) => _buildItemWidget(doc)).toList(),
                  ),
                );
              },
            )),
      ),
    );
  }

  //챌린지 항목 위젯
  Widget _buildItemWidget(DocumentSnapshot doc) {
    final challenge = Challenge(doc['title'], doc['point'], doc['iconNumber'],
        clear: doc['clear']);

    //하루가 지났을 경우, 챌린지의 clear를 false로 초기화
    if (updateDay.update) {
      updateDay.count--;
      if (updateDay.count == 0) {
        updateDay.update = false;
        updateDay.count = 6;
      }
      Firestore.instance
          .collection('challenge')
          .document(doc.documentID)
          .updateData({'clear': false});
      challenge.clear = doc['clear'];
    }

    //챌린지를 클리어 했다고 'ok'를 누를 경우 실행하는 함수
    Future clearChallenge() async {
      Firestore.instance
          .collection('challenge')
          .document(doc.documentID)
          .updateData({'clear': !doc['clear']});
      await Firestore.instance
          .collection('userData')
          .document('ILMQl5nJoRBL7RlfLtrd')
          .get()
          .then((DocumentSnapshot doc2) async {
        var point = doc2['point'];
        Firestore.instance
            .collection('userData')
            .document('ILMQl5nJoRBL7RlfLtrd')
            .updateData({'point': point + doc['point']});
        Firestore.instance
            .collection('userData')
            .document('ILMQl5nJoRBL7RlfLtrd')
            .updateData({'monthlyCount': 1 + doc2['monthlyCount']});
      });
      Navigator.of(context).pop();
    }

    if (challenge.clear)
      return InkWell(
          //챌린지 클리어한 경우
          onTap: () {
            var now = new DateTime.now();
            if (now.isAfter(updateDay.dt)) { //하루가 지난 경우
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('하루가 지났습니다!'),
                        content: Text('ok를 누르면 홈 화면으로 돌아갑니다.'),
                        actions: <Widget>[
                          FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()));
                              })
                        ]);
                  });
            } else { //하루가 지나지 않은 경우
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('이미 완료한 챌린지입니다!'),
                        content: Text('Ok를 눌러 창을 닫아주세요.'),
                        actions: <Widget>[
                          FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ]);
                  });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      iconList[doc['iconNumber']],
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text(
                          '${challenge.title}',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                        'assets/challengeClear.png',
                        height: 60,
                        width: 60,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ));
    else {
      return InkWell(
        //챌린지 클리어하지 않은 경우
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('챌린지를 클리어 하셨나요?'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('클리어 하셨다면 Ok를,'),
                        Text('아직 클리어 하지 않으셨다면 cancle을\n눌러주세요.'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          var now = new DateTime.now();
                          if (now.isAfter(updateDay.dt)) { //하루가 지난 경우
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text('하루가 지났습니다!'),
                                      content: Text('ok를 누르면 홈 화면으로 돌아갑니다.'),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyApp()));
                                            })
                                      ]);
                                });
                          } else {  //하루가 지나지 않은 경우
                            clearChallenge();
                          }
                        },
                        child: Text('Ok')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('cancle')),
                  ],
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    iconList[doc['iconNumber']],
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        '${challenge.title}',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: <Widget>[
                        Icon(Icons.tag_faces),
                        SizedBox(
                          height: 10,
                        ),
                        Text('행복지수 ${challenge.point}+'),
                      ],
                    ),
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
}

class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

//Event class
class EventInfo {
  String title;
  String subtitle;
  String main_img;
  String date;
  String reward;
  String event_url;
  bool is_done;

  EventInfo(this.title, this.subtitle, this.main_img, this.date, this.reward, this.event_url, {this.is_done = false});
}

class _EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          '이벤트',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('Event').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final documents = snapshot.data.documents;
                    return Column(
                      children: documents.map((doc) => _buildItemWidget(doc)).toList(),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  //이벤트 생성 및 상세 페이지로 연결
  Widget _buildItemWidget(DocumentSnapshot doc) {
    final event = EventInfo(doc['title'], doc['subtitle'], doc['main_img'], doc['date'], doc['reward'], doc['event_url']);

    var now = new DateTime.now();

    return Card(
      child: Container(
        width: double.infinity,
        height: 200,
        child: InkWell(
          onTap: () => _eventDetail(event),
          child: Column(
            children: <Widget>[
              AutoSizeText(event.title, ),
              Image.network(event.main_img, width: 70, height: 70,),
              AutoSizeText(event.subtitle,),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(event.date)),
            ],
          ),
        ),
      ),
    );
  }

  //이벤트 상세페이지
  Widget _eventDetail(EventInfo event) {

    final eventDetail = event.event_url;

    return Text('이벤트 상세페이지 입니다');
  }
}

//이벤트 상세페이지
class EventDetail extends StatefulWidget {
  EventDetail({Key key, this.title, EventInfo event}) : super(key: key);

  final String title;

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.024),
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.blue[100],
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(width * 0.024),
                    child: Image.asset(
                      'images/sample.png',
                      width: width * 0.2,
                      height: width * 0.2,
                    ),
                  ),
                  Container(
                    width: width * 0.7,
                    height: width * 0.3,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: width * 0.04),
                        ),
                        Text(
                          '2020환경의 날 SNS국민 참여 이벤트',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: width * 0.024),
                        ),
                        Text(
                          '2021년 02월 01일 ~ 2021년 2월 28일',
                          style: TextStyle(fontSize: 12),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: width * 0.024),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.money_off,
                                size: 12,
                              ),
                              Padding(
                                padding: EdgeInsets.all(width * 0.002),
                              ),
                              Text(
                                '편의점 상품권 2천원',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.blue[100],
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(width * 0.024),
                    child: Image.asset(
                      'images/sample.png',
                      width: width * 0.95,
                    ),
                  ),
                  SizedBox(
                    height: width * 0.024,
                  ),
                  Container(
                    width: width * 0.8,
                    child: Text(
                      "This text is very very very very very very very very very very very very very very very very very very very very very very very very very long",
                    ),
                  ),
                  SizedBox(
                    height: width * 0.024,
                  ),
                  RaisedButton(
                    child: Text(
                      '참가하기',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.pink[100],
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//팁 상세페이지
class TipsDetail extends StatefulWidget {
  @override
  _TipsDetailState createState() => _TipsDetailState();
}

class _TipsDetailState extends State<TipsDetail> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.024),
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.blue[100],
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(width * 0.024),
                    child: Image.asset(
                      'images/sample.png',
                      width: width * 0.2,
                      height: width * 0.2,
                    ),
                  ),
                  Container(
                    width: width * 0.7,
                    height: width * 0.3,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: width * 0.04),
                        ),
                        Text(
                          '2020환경의 날 SNS국민 참여 이벤트',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: width * 0.024),
                        ),
                        Text(
                          '2021년 02월 01일 ~ 2021년 2월 28일',
                          style: TextStyle(fontSize: 12),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: width * 0.024),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.money_off,
                                size: 12,
                              ),
                              Padding(
                                padding: EdgeInsets.all(width * 0.002),
                              ),
                              Text(
                                '편의점 상품권 2천원',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.blue[100],
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(width * 0.024),
                    child: Image.asset(
                      'images/sample.png',
                      width: width * 0.95,
                    ),
                  ),
                  SizedBox(
                    height: width * 0.024,
                  ),
                  Container(
                    width: width * 0.8,
                    child: Text(
                      "This text is very very very very very very very very very very very very very very very very very very very very very very very very very long",
                    ),
                  ),
                  SizedBox(
                    height: width * 0.024,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//정보&팁 페이지
class Tips extends StatefulWidget {
  @override
  _TipsState createState() => _TipsState();
}

//팁 클래스 선언 (DB에 사용할 필드)
class TipInfo {
  String title;
  String subtitle;
  String main_img;

  TipInfo(this.title, this.subtitle, this.main_img);
}

class _TipsState extends State<Tips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          '정보 & 꿀팁',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              StreamBuilder<QuerySnapshot> (
                stream: Firestore.instance.collection('Tips').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final documents = snapshot.data.documents;
                  return Column(
                    children: documents.map((doc) => _buildItemWidget(doc)).toList(),
                  );
                },
              ),
              SizedBox( height: 30,),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget (DocumentSnapshot doc) {
    final tip = TipInfo(doc['title'], doc['subtitle'], doc['main_img']);

    return InkWell(
      // 메서드 이름은 임의로 정했고 상세페이지로 넘어가는 기능입니다!
      onTap: () => _tipDetail(),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)),
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  tip.main_img),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(tip.title)),
        ),
      ),
    );
  }

  //tip 상세화면 보여주는 함수를 임의로 만들어놨습니다
  Widget _tipDetail() {

  }
}


//마이페이지
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
        Text('GREEN DAY에 오신 것을 환영합니다.',style: TextStyle(fontSize: 20,color: Colors.teal[700]))
        /*
        TextField(
          style: TextStyle(height: 0.3),
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'email을 입력하세요'),
        ),
        TextField(
          style: TextStyle(height: 0.3),
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Password를 입력하세요'),
        ),
        Text('google 계정으로 로그인'),

         */
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
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection('userData').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          final documents = snapshot.data.documents;
                          return Column(
                            children:
                            documents.map((doc) => _buildMyPageItemWidget(doc)).toList(),
                          );
                        },
                      ),
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

//마이페이지의 챌린지 성공 횟수 위젯
Widget _buildMyPageItemWidget(DocumentSnapshot doc) {
  final monthlyCount = doc['monthlyCount'];

  return Text(
    '$monthlyCount',
    style: TextStyle(fontSize: 25),
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