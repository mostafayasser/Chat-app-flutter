import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/friend.dart';


class ChatsScreen extends StatefulWidget {
  static const route = "/chatsScreen";
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  
  ScrollController scroll = ScrollController();
  final Firestore _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    final user_email = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body:
      Container(
        child:  Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('Messag')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                List<DocumentSnapshot> docs = snapshot.data.documents;
                //docs.retainWhere((item) => item.data['from'] != user_email);
                
                
               
                List<Widget> friends = docs
                    .map((doc) => Friend(
                          sender: doc.data['from'],
                        ))
                    .toSet().toList();
                   
                return ListView(
                  controller: scroll,
                
                  padding: EdgeInsets.all(8.0),
                  children: <Widget>[...friends],
                );
              },
            ),
          ),
        ],
      ),
      )
      
    );
  }
}
