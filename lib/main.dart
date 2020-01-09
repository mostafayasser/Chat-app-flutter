import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './screens/signup_screen.dart';
import './screens/main_screen.dart';
import './screens/login_screen.dart';
import './screens/friends_screen.dart';
import './screens/chats_screen.dart';

void main() => runApp(FriendlychatApp());

class FriendlychatApp extends StatelessWidget {
  final ThemeData iosTheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
  );

  final ThemeData androidTheme = ThemeData(
    primarySwatch: Colors.purple,
    accentColor: Colors.orangeAccent[400],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FriendlyChat',
      theme: ThemeData.dark(),
      home: MainScreen(),
      routes: {
        MainScreen.route: (ctx) => MainScreen(),
        SignupScreen.route: (ctx) => SignupScreen(),
        LoginScreen.route: (ctx) => LoginScreen(),
        ChatScreen.route: (ctx) => ChatScreen(),
        FriendsScreen.route: (ctx) => FriendsScreen(),
        ChatsScreen.route: (ctx) => ChatsScreen(),
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  static const route = "/chatScreen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  String friend;
  String user_name;
  String groupId;
  final _textController = TextEditingController();
  ScrollController scroll = ScrollController();
  bool _isComposing = false;
  FirebaseUser user;
  void getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    user_name = user.email.toString().split('@')[0];
    print(user_name);
    if (user_name.hashCode <= friend.hashCode)
      groupId = "$user_name-$friend";
    else
      groupId = "$friend-$user_name";
    print(groupId);
    
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  void _handleSubmitted(String text) async {
    getUser();

    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    await _firestore
        .collection('Messag')
        .document("$groupId")
        .collection("$groupId")
        .add({
      'text': text,
      'from': user.email,
      'date': DateTime.now().toIso8601String().toString()
    });
    scroll.animateTo(0.0,
        curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: "Send a message",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.android
                  ? IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                    )
                  : CupertinoButton(
                      child: Text("send"),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                    ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    String friend_name = ModalRoute.of(context).settings.arguments;
    friend = friend_name.split('@')[0];
    
    print(groupId);
    Future<void> _signOut() async {
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed(MainScreen.route);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("FriendlyChat"),
        elevation:
            Theme.of(context).platform == TargetPlatform.android ? 4.0 : 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: _firestore
                    .collection('Messag')
                    .document("$groupId")
                    .collection("$groupId")
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  
                  print("mess - $docs");
                  return ListView.builder(
                    controller: scroll,
                    reverse: true,
                    padding: EdgeInsets.all(8.0),
                    itemCount: docs.length,
                    itemBuilder: (ctx, index) => ChatMessage(
                      text: docs[index].data['text'],
                      sender: docs[index].data['from'],
                      senderMe: user.email == docs[index].data['from'],
                    ),
                  );
                },
              ),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool senderMe;
  final String sender;

  ChatMessage({this.text, this.senderMe, this.sender});
  @override
  Widget build(BuildContext context) {
    return senderMe
        ? getSentMessages(sender, text)
        : getRecievedMessages(sender, text);
  }
}

Widget getSentMessages(String sender, text) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(sender.split("@")[0],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          child: CircleAvatar(
            child: Text(sender[0]),
          ),
        ),
      ],
    ),
  );
}

Widget getRecievedMessages(sender, text) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10),
          child: CircleAvatar(
            child: Text(sender[0]),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(sender.split("@")[0],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
      ],
    ),
  );
}
