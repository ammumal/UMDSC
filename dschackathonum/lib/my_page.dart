import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//마이페이지
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

DateTime now = DateTime.now();
DateTime _selectedTime;

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
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4.0,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      RaisedButton(
                        onPressed: () {
                          Future<DateTime> selectedDate = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2018),
                            lastDate: DateTime(2030),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.dark(),
                                child: child,
                              );
                            },
                          );

                          selectedDate.then((dateTime) {
                            setState(() {
                              _selectedTime = dateTime;
                            });
                          });
                        },
                        child: Text(
                            'Today : ${now.year.toString()} / ${now.month.toString()}',
                            style: TextStyle(fontSize: 30)),
                      ),
                      Text('Tap the button above to change the date\n'),
                      //Text('${_selectedTime.year.toString()} - ${_selectedTime.month.toString()}', style: TextStyle(fontSize: 35),),

                      //챌린지 성공 횟수, 이벤트 성공 횟수
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('userData')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          final document = snapshot.data.documents.first;
                          final monthlyCount = document['monthlyCount'];
                          final monthlyCountE = document['monthlyCountE'];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.stars,
                                    size: 100,
                                    color: Colors.amber,
                                  ),
                                  Text('Number of Challenges'),
                                  Text(
                                    '$monthlyCount',
                                    style: TextStyle(fontSize: 25),
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
                                  Text('Number of Event'),
                                  Text(
                                    '$monthlyCountE',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                width: 380,
                height: 250,
              ),
            ),
          ),
          //Text('${_selectedTime.year.toString()}-${_selectedTime.month.toString()}'),

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
        Text('GREEN DAY에 오신 것을 환영합니다.',
            style: TextStyle(fontSize: 20, color: Colors.teal[700]))
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
        title: Text('Alarm setting'),
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
            'ABOUT GREEN DAY\n\nThe Green Day application created by 4 dsc sungshin members was planned with the '
            'focus on the destruction of the ecosystem of animals such as rising sleep and depletion of resources due to climate change.\n\n '
            'Your daily challenges will make polar bears, elephants, bengal tigers and cheetahs happy.\n '
            'You can also view and experience various information and events related to the environment.\n\n '
            'Please praise yourself for your efforts for future generations through this application.\n\nThank you.'),
        subtitle: Text('[Developers: Yebin Kang, Minseo Yoo, Jieun Lee]'),
      ),
    ],
  );
}
