import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  final _url = "www.google.com" ;

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
      onTap: _launchURL,
      child: Column(
        children: <Widget>[
          Card(
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
          SizedBox(height: 15,),
        ],
      ),
    );
  }

  //웹사이트로 넘어가는 메서드(미완)
  void _launchURL() {}
}
