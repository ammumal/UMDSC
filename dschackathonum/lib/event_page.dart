import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//이벤트 페이지
class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}

//Event class (db field)
class EventInfo {
  String id;
  String title;
  String subtitle;
  String main_img;
  String date;
  String reward;
  String event_url;
  bool is_done;

  EventInfo(this.id, this.title, this.subtitle, this.main_img, this.date, this.reward, this.event_url, {this.is_done = false});
}

//이벤트 기본 화면입니다 여기에 이벤트 인스턴스 틀을 따로 만들어서 넣어주었어요
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

  //이벤트 생성
  Widget _buildItemWidget(DocumentSnapshot doc) {

    final event = EventInfo(doc['id'], doc['title'], doc['subtitle'], doc['main_img'], doc['date'], doc['reward'], doc['event_url']);
    var eventId = event.id;

    return Card(
      child: Container(
        width: double.infinity,
        height: 200,
        child: InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => EventDetail(eventId: eventId,))
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 15,),
                  Image.network(event.main_img, width: 150, height: 150,),
                  SizedBox(width: 15,),
                  Expanded(child: Text(event.title,)),
                  // AutoSizeText(event.subtitle,),
                ],
              ),
              SizedBox(height: 15,),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Text('마감 날짜: ' + event.date)),
            ],
          ),
        ),
      ),
    );
  }
}

//이벤트 상세 페이지
class EventDetail extends StatefulWidget {
  final String eventId;

  EventDetail({@required this.eventId});

  @override
  _EventDetailState createState() => _EventDetailState(eventId: eventId);
}

class _EventDetailState extends State<EventDetail> {

  var eventId;

  _EventDetailState({@required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Event Detail',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance.collection('Event').document(eventId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
                return CircularProgressIndicator();
              }
              var event = snapshot.data;
              return Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15,),
                    Image.network(event['main_img'], width: 300, height: 300,),
                    SizedBox(height: 30,),
                    Text(event['subtitle']),
                    SizedBox(height: 15,),
                    Row(
                      children: <Widget>[
                        Text('보상: '),
                        Text(event['reward']),
                      ],
                    ),
                    RaisedButton(
                      onPressed: _launchEvent,
                      child: Text('참여하기'),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

  }

  //참여하기 버튼 누르면 연결된 페이지(미완)
  void _launchEvent() {

  }
}

