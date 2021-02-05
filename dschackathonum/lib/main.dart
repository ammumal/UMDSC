import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(title: 'MyApp', home: initViewsample()));

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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
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

//하루가 지났는지 확인
class UpdateDay {
  bool update = false;
  int count = 6;
  DateTime dt;
  bool display = false;

  UpdateDay({this.dt});
}

UpdateDay updateDay = new UpdateDay();

class _HomeState extends State<Home> {
  //웃는 동물 사진 리스트(사진 변경 시 jpg, png 유의!)
  var happyAnimalList = [
    'assets/happyAnimal0.png',
    'assets/happyAnimal1.png',
    'assets/happyAnimal2.png',
    'assets/happyAnimal3.png'
  ];

  //우는 동물 사진 리스트(사진 변경 시 jpg, png 유의!)
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
            StreamBuilder<QuerySnapshot>(
              //행복지수, 동물 그림
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
            RaisedButton(
              // Week Challenge 버튼
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

  //행복 지수, 동물 그림 위젯
  Widget _buildItemWidget(DocumentSnapshot doc) {
    final happiness = Happiness(doc['point']);
    final animal = Animal(doc['animalNumber']);

    var now = new DateTime.now();
    updateDay.dt = new DateTime.fromMillisecondsSinceEpoch(
        doc['updateTime'].seconds * 1000);

    if (now.isAfter(updateDay.dt)) {
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
      updateDay.update = true;
    }

    if (happiness.point < 100) {
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
          )
        ],
      );
    } else {
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
          )
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

    Future updateChallenge() async {
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
      });
      Navigator.of(context).pop();
    }

    if (challenge.clear)
      return InkWell(
          //챌린지 클리어한 경우
          onTap: () {
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
          var now = new DateTime.now();
          if (now.isAfter(updateDay.dt)) {
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
          } else {
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
                            if (now.isAfter(updateDay.dt)) {
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
                            } else {
                              updateChallenge();
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
              border: OutlineInputBorder(), labelText: 'email을 입력하세요'),
        ),
        TextField(
          style: TextStyle(height: 0.3),
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Password를 입력하세요'),
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
